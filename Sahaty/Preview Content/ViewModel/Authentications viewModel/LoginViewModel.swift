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
    private let defaultEmail = "mido@gmail.com"
    private let defaultPassword = "123456"

    // التحقق من تسجيل الدخول
    func validateLogin() -> Bool {
        clearErrors()
        var isValid = true

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "يرجى إدخال بريد إلكتروني صحيح."
            isValid = false
        } else if model.email != defaultEmail {
            emailErrorMessage = "البريد الإلكتروني غير صحيح."
            isValid = false
        }

        if model.password.isEmpty || model.password.count < 6 {
            passwordErrorMessage = "يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل."
            isValid = false
        } else if model.password != defaultPassword {
            passwordErrorMessage = "كلمة المرور غير صحيحة."
            isValid = false
        }

        if isValid {
            successMessage = "تم تسجيل الدخول بنجاح! 🥳"
        }

        return isValid
    }

    private func clearErrors() {
        emailErrorMessage = ""
        passwordErrorMessage = ""
    }
}
