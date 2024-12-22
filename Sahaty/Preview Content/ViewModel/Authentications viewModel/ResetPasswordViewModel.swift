//
//  ResetPasswordViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

class ResetPasswordViewModel: ObservableObject {
    @Published var model = ResetPasswordModel(email: "", otpCode: nil, newPassword: nil, confirmPassword: nil)

    // رسائل الأخطاء
    @Published var emailErrorMessage: String = ""
    @Published var otpErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var successMessage: String = ""

    // بيانات افتراضية (للتجربة فقط)
    private let defaultEmail = "mido@gmail.com"
    private let defaultOtp = "1234"

    // التحقق من البريد الإلكتروني
    func validateEmail() -> Bool {
        clearErrors()
        var isValid = true

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "يرجى إدخال بريد إلكتروني صحيح."
            isValid = false
        } else if model.email != defaultEmail {
            emailErrorMessage = "البريد الإلكتروني غير موجود."
            isValid = false
        }

        if isValid {
            successMessage = "تم إرسال رمز OTP بنجاح."
        }

        return isValid
    }

    // التحقق من رمز OTP
    func validateOtp() -> Bool {
        clearErrors()
        var isValid = true

        if let otpCode = model.otpCode, otpCode.isEmpty || otpCode != defaultOtp {
            otpErrorMessage = "رمز OTP غير صحيح."
            isValid = false
        }

        if isValid {
            successMessage = "تم التحقق بنجاح! 🎉"
        }

        return isValid
    }

    // التحقق من كلمة المرور الجديدة
    func validateNewPassword() -> Bool {
        clearErrors()
        var isValid = true

        if let newPassword = model.newPassword, newPassword.isEmpty || newPassword.count < 6 {
            passwordErrorMessage = "يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل."
            isValid = false
        }

        if model.confirmPassword != model.newPassword {
            confirmPasswordErrorMessage = "كلمة المرور وتأكيدها غير متطابقين."
            isValid = false
        }

        if isValid {
            successMessage = "تم إعادة تعيين كلمة المرور بنجاح! 🥳"
        }

        return isValid
    }

    private func clearErrors() {
        emailErrorMessage = ""
        otpErrorMessage = ""
        passwordErrorMessage = ""
        confirmPasswordErrorMessage = ""
    }
}
