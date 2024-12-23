//
//  SignUpViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/16/24.
//


import Foundation
class SignUpViewModel: ObservableObject {
    @Published var confirmPasswordText: String = ""

    @Published var model = SignUpModel(
        fullName: "",
        email: "",
        password: "",
        confirmPassword: "",
        specialization: nil,
        licenseNumber: nil,
        userType: .patient
    )

    @Published var fullNameErrorMessage: String = ""
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var specializationErrorMessage: String = ""
    @Published var licenseNumberErrorMessage: String = ""
    @Published var signUpSuccessMessage: String = ""
    @Published var isLoading: Bool = false


    /// التحقق من البيانات وتحويلها إلى النموذج المناسب
    func registerUser(completion: (Result<UserModel, Error>) -> Void) {
        // 1. التحقق من صحة البيانات
        guard validateSignUp() else {
            completion(.failure(SignUpError.invalidData))
            return
        }
        
        // 2. إنشاء UserModel
        let user = UserModel(
            fullName: model.fullName,
            email: model.email,
            profilePicture: nil,
            age: nil,
            gender: .male, // يمكن تعيينها حسب الاختيار
            userType: model.userType
        )
        
        isLoading = true
          DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
              guard let self = self else { return }
              self.isLoading = false

              // محاكاة نجاح التسجيل
              DispatchQueue.main.async {
                  self.signUpSuccessMessage = "تم تسجيل الحساب بنجاح!"
              }
          }

        // 3. إنشاء DoctorModel أو PatientModel
        if model.userType == .doctor {
            guard let specialization = model.specialization,
                  let licenseNumber = model.licenseNumber else {
                completion(.failure(SignUpError.missingDoctorFields))
                return
            }
            let doctor = DoctorModel(
                user: user,
                specialization: specialization,
                licenseNumber: licenseNumber,
                biography: nil
            )
            saveDoctor(doctor)
            completion(.success(user))
        } else {
            let patient = PatientModel(
                user: user,
                followedDoctorIds: [],
                favoriteArticleIds: [],
                favoriteAdviceIds: []
            )
            savePatient(patient)
            completion(.success(user))
        }
    }

    // التحقق من صحة البيانات
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
            if model.specialization?.isEmpty ?? true {
                specializationErrorMessage = "يرجى إدخال التخصص."
                isValid = false
            }

            if model.licenseNumber?.isEmpty ?? true {
                licenseNumberErrorMessage = "يرجى إدخال رقم الترخيص."
                isValid = false
            }
        }

        if isValid {
            signUpSuccessMessage = "تم إنشاء الحساب بنجاح!"
        }

        return isValid
    }

    private func saveDoctor(_ doctor: DoctorModel) {
        // إرسال بيانات الطبيب إلى الخادم أو تخزينها محليًا
        print("تم حفظ الطبيب: \(doctor)")
    }

    private func savePatient(_ patient: PatientModel) {
        // إرسال بيانات المريض إلى الخادم أو تخزينها محليًا
        print("تم حفظ المريض: \(patient)")
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

// أخطاء محتملة أثناء التسجيل
enum SignUpError: Error, LocalizedError {
    case invalidData
    case missingDoctorFields

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "البيانات غير صحيحة."
        case .missingDoctorFields:
            return "يرجى إدخال التخصص ورقم الترخيص للطبيب."
        }
    }
}



