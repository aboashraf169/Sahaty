//
//  SignUpViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

class SignUpViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var model = SignUpModel(
        fullName: "",
        email: "",
        password: "",
        specialization: nil,
        licenseNumber: nil,
        usersType: .patient
    )
    
    @Published var fullNameErrorMessage: String = ""
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var specializationErrorMessage: String = ""
    @Published var licenseNumberErrorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    // MARK: - Validation and API Call
    func validateAndSignUp(completion: @escaping (Bool) -> Void) {
        clearErrors()
        guard validateSignUp() else {
            completion(false)
            return
        }
        
        // Call API to register user
        signUpUser(completion: completion)
    }
    
    private func validateSignUp() -> Bool {
        var isValid = true

        if model.fullName.isEmpty || model.fullName.count <= 2 {
            fullNameErrorMessage = "enter_full_name".localized()
            isValid = false
        }

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "enter_valid_email".localized()
            isValid = false
        }

        if model.password.isEmpty || model.password.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            isValid = false
        }

        if model.usersType == .doctor {
            if let specialization = model.specialization, specialization.isEmpty {
                specializationErrorMessage = "enter_specialization".localized()
                isValid = false
            }

            if let licenseNumber = model.licenseNumber, licenseNumber.isEmpty {
                licenseNumberErrorMessage = "enter_license_number".localized()
                isValid = false
            }
        }

        return isValid
    }
    
    private func clearErrors() {
        fullNameErrorMessage = ""
        emailErrorMessage = ""
        passwordErrorMessage = ""
        confirmPasswordErrorMessage = ""
        specializationErrorMessage = ""
        licenseNumberErrorMessage = ""
        successMessage = ""
        errorMessage = "" // Reset general error message
    }
    
    private func signUpUser(completion: @escaping (Bool) -> Void) {
        isLoading = true
        APIManager.shared.sendRequest(
            endpoint: "/register",
            method: .post,
            parameters: model.toDictionary()
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    do {
                        // محاولة تحويل البيانات إلى JSON
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let token = json["token"] as? String {
                            // تعيين التوكن في APIManager
                            APIManager.shared.setBearerToken(token)
                            self?.successMessage = "signup_success".localized()
                            print("SignUp Success: \(json)")
                            print("Token Saved: \(token)")
                            completion(true)
                        } else {
                            self?.errorMessage = "response_parsing_error".localized()
                            print("SignUp Failed: Invalid Response")
                            completion(false)
                        }
                    } catch {
                        self?.errorMessage = "response_parsing_error".localized()
                        print("SignUp Failed: \(error.localizedDescription)")
                        completion(false)
                    }
                case .failure(let error):
                    self?.handleAPIError(error)
                    completion(false)
                }
            }
        }
    }
    
    private func handleAPIError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .decodingError:
                emailErrorMessage = "response_parsing_error".localized()
            default:
                errorMessage = error.localizedDescription // استخدم خطأ عام
            }
        } else {
            errorMessage = error.localizedDescription // خطأ عام
        }
        print("API Error: \(error.localizedDescription)")
    }
}
