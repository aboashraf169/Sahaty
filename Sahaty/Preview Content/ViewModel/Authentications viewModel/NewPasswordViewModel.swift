//
//  NewPasswordViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

class NewPasswordViewModel: ObservableObject {
    // MARK: - Model
    @Published var model = NewPasswordModel(password: "", confirmPassword: nil)

    // MARK: - Error Messages
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""

    // MARK: - Success Message
    @Published var successMessage: String = ""

    // MARK: - Validation for New Password
    func validateNewPassword() -> Bool {
        clearErrors()
        var isValid = true

        // التحقق من كلمة المرور
        if model.password.isEmpty {
            passwordErrorMessage = "يرجى إدخال كلمة المرور"
            isValid = false
        } else if model.password.count < 6 {
            passwordErrorMessage = "يجب أن تكون كلمة المرور 6 أحرف على الأقل"
            isValid = false
        }

        // التحقق من تأكيد كلمة المرور
        if model.confirmPassword != model.password {
            confirmPasswordErrorMessage = "كلمة المرور وتأكيدها غير متطابقين"
            isValid = false
        }

        // إذا كان كل شيء صحيحًا
        if isValid {
            successMessage = "تم تعديل كلمة السر بنجاح!"
        }

        return isValid
    }

    // MARK: - Clear Errors
    func clearErrors() {
        passwordErrorMessage = ""
        confirmPasswordErrorMessage = ""
    }
}
