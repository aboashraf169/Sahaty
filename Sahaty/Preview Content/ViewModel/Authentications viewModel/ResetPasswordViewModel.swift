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
            emailErrorMessage = "enter_valid_email".localized()
            isValid = false
        } else if model.email != defaultEmail {
            emailErrorMessage = "email_not_found".localized()
            isValid = false
        }

        if isValid {
            successMessage = "otp_sent_success".localized()
        }

        return isValid
    }

    // التحقق من رمز OTP
    func validateOtp() -> Bool {
        clearErrors()
        var isValid = true

        if let otpCode = model.otpCode, otpCode.isEmpty || otpCode != defaultOtp {
            otpErrorMessage = "incorrect_otp".localized()
            isValid = false
        }

        if isValid {
            successMessage = "otp_verification_success".localized()
        }

        return isValid
    }

    // التحقق من كلمة المرور الجديدة
    func validateNewPassword() -> Bool {
        clearErrors()
        var isValid = true

        if let newPassword = model.newPassword, newPassword.isEmpty || newPassword.count < 6 {
            passwordErrorMessage = "password_min_length".localized()
            isValid = false
        }

        if model.confirmPassword != model.newPassword {
            confirmPasswordErrorMessage = "passwords_not_matching".localized()
            isValid = false
        }

        if isValid {
            successMessage = "password_reset_success".localized()
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
