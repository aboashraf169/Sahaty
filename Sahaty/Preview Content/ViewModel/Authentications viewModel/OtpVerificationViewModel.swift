//
//  OtpVerificationViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


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
            otpErrorMessage = "يرجى إدخال رمز التحقق المكون من 4 أرقام"
            isValid = false
        } else if model.otpCode != "1234" { // رمز افتراضي للتحقق
            otpErrorMessage = "رمز التحقق غير صحيح"
            isValid = false
        }

        if isValid {
            successMessage = "تم التحقق بنجاح!"
        }

        return isValid
    }

    // MARK: - Clear Errors
    func clearErrors() {
        otpErrorMessage = ""
    }

    // MARK: - Resend OTP
    func resendOtp() {
        print("تم إعادة إرسال رمز OTP إلى البريد الإلكتروني: \(model.email)")
    }
}
