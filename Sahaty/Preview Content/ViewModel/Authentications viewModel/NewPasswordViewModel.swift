//
//  NewPasswordViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

class NewPasswordViewModel: ObservableObject {
    // MARK: - Model
    @Published var model = NewPasswordModel(password: "")

    // MARK: - Error Messages
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var oldPasswordErrorMessage: String = ""

    // MARK: - Success Message
    @Published var successMessage: String = ""

    // MARK: - Validation for New Password
    func validateNewPassword() -> Bool {
        clearErrors()
        var isValid = true

        // التحقق من كلمة المرور
        if model.password.isEmpty {
            passwordErrorMessage = "enter_password".localized()
            isValid = false
        } else if model.password.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            isValid = false
        }

        // التحقق من تأكيد كلمة المرور
        if model.confirmPassword != model.password {
            confirmPasswordErrorMessage = "passwords_not_matching".localized()
            isValid = false
        }
        
        // التحقق من كلمة المرور القديمة
        if model.oldPassword != model.password {
            oldPasswordErrorMessage = "incorrect_old_password".localized()
            isValid = false
        }

        // إذا كان كل شيء صحيحًا
        if isValid {
            successMessage = "password_change_success".localized()
        }

        return isValid
    }

    // MARK: - Clear Errors
    func clearErrors() {
        passwordErrorMessage = ""
        confirmPasswordErrorMessage = ""
        oldPasswordErrorMessage = ""
    }
}



