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

        if model.confirmPassword != model.password {
            confirmPasswordErrorMessage = "passwords_not_matching".localized()
            isValid = false
        }

        if model.userType == .doctor {
            if let specialization = model.specialization, specialization.isEmpty {
                specializationErrorMessage = "enter_specialization".localized()
                isValid = false
            }

            if let licenseNumber = model.licenseNumber, licenseNumber.isEmpty {
                licenseNumberErrorMessage = "enter_license_number".localized()
                isValid = false
            }
        }

        if isValid {
            successMessage = "signup_success".localized()
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
