//
//  LoginViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

class LoginViewModel: ObservableObject {
    @Published var model = LoginModel(email: "", password: "", userType: .patient)

    // رسائل الأخطاء
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var successMessage: String = ""

    // بيانات افتراضية (للتجربة فقط)
    private let defaultEmail = "Mido@gmail.com"
    private let defaultPassword = "123456"

    // التحقق من تسجيل الدخول
    func validateLogin() -> Bool {
        clearErrors()
        var isValid = true

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "enter_valid_email".localized()
            isValid = false
        } else if model.email != defaultEmail {
            emailErrorMessage = "incorrect_email".localized()
            isValid = false
        }

        if model.password.isEmpty || model.password.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            isValid = false
        } else if model.password != defaultPassword {
            passwordErrorMessage = "incorrect_password".localized()
            isValid = false
        }

        if isValid {
            successMessage = "login_success".localized()
        }

        return isValid
    }

    private func clearErrors() {
        emailErrorMessage = ""
        passwordErrorMessage = ""
    }
}

