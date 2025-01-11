import Foundation

class OtpVerificationViewModel: ObservableObject {
    // MARK: - Model
    @Published var model = OtpVerificationModel(email: "", otpCode: "")

    // MARK: - Error Message
    @Published var otpErrorMessage: String = ""

    // MARK: - Success Message
    @Published var successMessage: String = ""

    // MARK: - Validate OTP
    func validateOtp() -> Bool {
        clearErrors()
        var isValid = true

        if model.otpCode.isEmpty || model.otpCode.count != 4 {
            otpErrorMessage = "enter_valid_otp".localized()
            isValid = false
        } else if model.otpCode != "1234" { // رمز افتراضي للتحقق
            otpErrorMessage = "incorrect_otp".localized()
            isValid = false
        }

        if isValid {
            successMessage = "otp_verification_success".localized()
        }

        return isValid
    }

    // MARK: - Clear Errors
    func clearErrors() {
        otpErrorMessage = ""
    }

    // MARK: - Resend OTP
    func resendOtp() {
        print("otp_resend_message".localized() + ": \(model.email)")
    }
}
