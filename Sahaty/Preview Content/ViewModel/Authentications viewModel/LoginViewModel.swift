//
//  LoginViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

class LoginViewModel: ObservableObject {
    @Published var model = LoginModel(email: "", password: "", usersType: .patient)

    // رسائل الأخطاء
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var apiErrorMessage: String = "" // لإظهار الأخطاء القادمة من الخادم
    @Published var successMessage: String = ""
    @Published var isLoading: Bool = false

    // التحقق من تسجيل الدخول
    func validateAndLogin(completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateLogin() else {
            completion(false)
            return
        }
        
        // Call API for login
        loginUser(completion: completion)
    }

    private func validateLogin() -> Bool {
        var isValid = true

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "enter_valid_email".localized()
            isValid = false
        }

        if model.password.isEmpty || model.password.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            isValid = false
        }

        return isValid
    }

    private func clearErrors() {
        emailErrorMessage = ""
        passwordErrorMessage = ""
        apiErrorMessage = "" // إعادة تعيين رسائل الأخطاء العامة
        successMessage = ""
    }

    private func loginUser(completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        APIManager.shared.sendRequest(
            endpoint: "/login",
            method: .post,
            parameters: model.toDictionary()
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.handleLoginSuccess(data: data, completion: completion)
                case .failure(let error):
                    self?.handleAPIError(error)
                    completion(false)
                }
            }
        }
        
    }

    private func handleLoginSuccess(data: Data, completion: @escaping (Bool) -> Void) {
        do {
            // محاولة فك البيانات القادمة من الـ API
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let token = json["token"] as? String,
                  let userInfo = json["user"] as? [String: Any],
                  let isDoctor = userInfo["is_doctor"] as? Bool else {
                // إذا فشل فك البيانات أو لم يتم العثور على الحقول المتوقعة
                apiErrorMessage = "invalid_credentials".localized()
                print("Login Response Error: Missing expected fields.")
                completion(false)
                return
            }
            
            // إذا نجح تسجيل الدخول
            successMessage = "login_success".localized()
            print("Login Response: \(json)")

            // التحقق من أن اختيار المستخدم يطابق النوع الحقيقي
            if (model.usersType == .doctor && !isDoctor) || (model.usersType == .patient && isDoctor) {
                apiErrorMessage = "user_type_mismatch".localized() // رسالة توضح الخطأ
                print("User type mismatch: Selected \(model.usersType), Server returned \(isDoctor ? "Doctor" : "Patient")")
                completion(false)
                return
            }

            // تخزين التوكن
            if KeychainManager.shared.saveToken(token) {
                print("Token saved successfully.")
            } else {
                print("Failed to save token.")
            }
            APIManager.shared.setBearerToken(token)

            // تحديث نوع المستخدم بناءً على الرد
            model.usersType = isDoctor ? .doctor : .patient

            // تحويل بيانات المستخدم إلى النموذج المناسب
            if let userModel = mapUserInfoToModel(userInfo: userInfo, isDoctor: isDoctor)  as? DoctorModel{
                CoreDataManager.shared.saveDoctor(userModel)
                print("Job Specialty Number from API: \(userInfo["jop_specialty_number"] ?? "Not Found")")
                print("Doctor data saved successfully to Core Data.")
                SessionManager.shared.saveSession(token: token, userType: model.usersType, userData: userInfo)
                print("Session saved successfully with user data.")
            } else {
                print("Failed to map user info to model.")
                apiErrorMessage = "response_parsing_error".localized()
                completion(false)
                return
            }

            completion(true)
        } catch {
            // التعامل مع أي خطأ أثناء فك البيانات
            apiErrorMessage = "response_parsing_error".localized()
            print("Error parsing login response: \(error.localizedDescription)")
            completion(false)
        }
    }

    private func mapUserInfoToModel(userInfo: [String: Any], isDoctor: Bool) -> Any? {
        if isDoctor {
            // تحويل بيانات الدكتور إلى DoctorModel
            let specialties = (userInfo["specialty"] as? [[String: Any]])?.compactMap { specialtyData in
                Specialty(
                    id: specialtyData["id"] as? Int ?? 0,
                    name: specialtyData["name"] as? String ?? "",
                    description: specialtyData["description"] as? String ?? ""
                )
            } ?? []
            let jobSpecialtyNumber = (userInfo["jop_specialty_number"] as? Int)
                ?? Int(userInfo["jop_specialty_number"] as? String ?? "")
                ?? 0
            print("Mapping Job Specialty Number: \(userInfo["jop_specialty_number"] ?? "Not Found")")
            return DoctorModel(
                id: userInfo["id"] as? Int ?? 0,
                name: userInfo["name"] as? String ?? "",
                email: userInfo["email"] as? String ?? "",
                isDoctor: userInfo["is_doctor"] as? Int ?? 0,
                jobSpecialtyNumber: jobSpecialtyNumber, // تأكد من تعيين القيمة الصحيحة
                bio: userInfo["bio"] as? String,
                specialties: specialties
            )
            
        } else {
            // تحويل بيانات المريض إلى PatiantModel
            return PatiantModel(
                id: userInfo["id"] as? Int ?? 0,
                fullName: userInfo["name"] as? String ?? "",
                email: userInfo["email"] as? String ?? "",
                profilePicture: userInfo["profile_picture"] as? String,
                age: userInfo["age"] as? Int,
                gender: userInfo["gender"] as? String,
                medicalHistory: userInfo["medical_history"] as? String,
                followedDoctors: (userInfo["followed_doctors"] as? [[String: Any]])?.compactMap { doctorData in
                    let specialties = (doctorData["specialty"] as? [[String: Any]])?.compactMap { specialtyData in
                        Specialty(
                            id: specialtyData["id"] as? Int ?? 0,
                            name: specialtyData["name"] as? String ?? "",
                            description: specialtyData["description"] as? String ?? ""
                        )
                    } ?? []
                    
                    return DoctorModel(
                        id: doctorData["id"] as? Int ?? 0,
                        name: doctorData["name"] as? String ?? "",
                        email: doctorData["email"] as? String ?? "",
                        isDoctor: userInfo["is_doctor"] as? Int ?? 0,
                        jobSpecialtyNumber: doctorData["jop_specialty_number"] as? Int ?? 0,
                        bio: doctorData["bio"] as? String,
                        specialties: specialties
                    )
                }
            )
        }
    }


    private func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .decodingError:
                apiErrorMessage = "response_parsing_error".localized()
            case .serverError(let message):
                apiErrorMessage = message // رسالة الخطأ القادمة من الخادم
            default:
                apiErrorMessage = "unknown_error".localized()
            }
        } else {
            apiErrorMessage = error.localizedDescription
        }
        print("API Error: \(apiErrorMessage)")
    }

    
    private func extractToken(from response: String) -> String? {
        guard let data = response.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let token = json["token"] as? String else {
            return nil
        }
        return token
    }
}
