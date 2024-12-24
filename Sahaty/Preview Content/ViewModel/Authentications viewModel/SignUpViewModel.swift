//
//  SignUpViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation

class SignUpViewModel: ObservableObject {
    

    @Published var model = SignUpModel(
        fullName: "",
        email: "",
        password: "",
        confirmPassword: "",
        specialization: nil,
        licenseNumber: nil,
        userType: .patient
    )
    

    // رسائل الأخطاء
    @Published var fullNameErrorMessage: String = ""
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var specializationErrorMessage: String = ""
    @Published var licenseNumberErrorMessage: String = ""
    @Published var successMessage: String = ""

    @Published var confirmPasswordText: String = ""

    // التحقق من إنشاء الحساب
    func validateSignUp() -> Bool {
        clearErrors()
        var isValid = true

        if model.fullName.isEmpty || model.fullName.count <= 2 {
            fullNameErrorMessage = "يرجى إدخال الاسم الرباعي."
            isValid = false
        }

        if model.email.isEmpty || !model.email.contains("@") {
            emailErrorMessage = "يرجى إدخال بريد إلكتروني صحيح."
            isValid = false
        }

        if model.password.isEmpty || model.password.count < 6 {
            passwordErrorMessage = "يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل."
            isValid = false
        }

        if model.confirmPassword != model.password {
            confirmPasswordErrorMessage = "كلمة المرور وتأكيدها غير متطابقين."
            isValid = false
        }

        if model.userType == .doctor {
            if let specialization = model.specialization, specialization.isEmpty {
                specializationErrorMessage = "يرجى إدخال التخصص."
                isValid = false
            }

            if let licenseNumber = model.licenseNumber, licenseNumber.isEmpty {
                licenseNumberErrorMessage = "يرجى إدخال رقم الترخيص."
                isValid = false
            }
        }

        if isValid {
            successMessage = "تم إنشاء الحساب بنجاح! 🥳"
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
    }
}
