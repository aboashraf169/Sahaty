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
            
            // Save session
            SessionManager.shared.saveSession(token: token, userType: model.usersType, userData: userInfo)
            
            completion(true)
        } catch {
            // التعامل مع أي خطأ أثناء فك البيانات
            apiErrorMessage = "response_parsing_error".localized()
            print("Error parsing login response: \(error.localizedDescription)")
            completion(false)
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
