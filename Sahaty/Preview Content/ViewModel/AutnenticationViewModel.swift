
import Foundation

class AuthenticationViewModel: ObservableObject {
    
    // object for model
    @Published var model = AuthenticationModel(
        fullName: "",
        email: "",
        password: "",
        confirmPassword: nil,
        specialization: "",
        licenseNumber: "",
        userType: .patient
    )
    
    // بيانات افتراضية
    private let  defaultEmail = "mido@gmail.com"
    private let defaultPassword = "123456"
    private let defaultFullName = "mohammed"
    private let defaultSpecialization = "Cardiology"
    private let defaultLicenseNumber = "12345"
    private let defaultOtp = "1234"
    
    
    // رسائل الاخطاء
    @Published var emailErrorMessage: String = ""
    @Published var passwordErrorMessage: String = ""
    @Published var fullNameErrorMessage: String = ""
    @Published var confirmPasswordErrorMessage: String = ""
    @Published var specializationErrorMessage: String = ""
    @Published var licenseNumberErrorMessage: String = ""
    @Published var otpErrorMessage: String = ""
    @Published var otpCode: String = ""
    
    // رسالة النجاح
    @Published var successMessage: String = ""
    
    // تحقق تسجيل الدخول
    func validateLogin() -> Bool {
            clearErrors()
            var isValid = true
        
            if model.email.isEmpty || !model.email.contains("@") {
                emailErrorMessage = "يرجى إدخال بريد إلكتروني صحيح."
                isValid = false
            }else if model.email != defaultEmail {
                emailErrorMessage = "البريد الإلكتروني غير صحيح."
                isValid = false
            }
            if model.password.isEmpty || model.password.count < 6 {
                passwordErrorMessage = "يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل."
                isValid = false
            }else if model.password != defaultPassword {
                passwordErrorMessage = "كلمة المرور غير صحيحة."
                isValid = false
            }
            if isValid {
                successMessage = "🥳تم تسجيل الدخول بنجاح!"
            }
        
            return isValid
        }
    
     // تحقق انشاء حساب
    func validateSignUp() -> Bool {
        clearErrors()
        
        var isValid = true
        
        if model.fullName.isEmpty {
            fullNameErrorMessage = "الحقل مطلوب"
            isValid = false
        } else if model.fullName.count <= 2 {
            fullNameErrorMessage = "يرجى إدخال الاسم الرباعي."
            isValid = false
        }
        
        if model.email.isEmpty {
            emailErrorMessage = "الحقل مطلوب"
            isValid = false
        } else if !model.email.contains("@") {
            emailErrorMessage = "يرجى إدخال بريد إلكتروني صحيح."
            isValid = false
        }
        
        if model.password.isEmpty {
            passwordErrorMessage = "الحقل مطلوب"
            isValid = false
        } else if model.password.count < 6 {
            passwordErrorMessage = "يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل."
            isValid = false
        }

        if model.confirmPassword != model.password {
            confirmPasswordErrorMessage = "كلمة المرور وتأكيدها غير متطابقين."
            isValid = false
        }
        
        if model.userType == .doctor {
            if let specialization = model.specialization, specialization.isEmpty {
                specializationErrorMessage = "الحقل مطلوب"
                isValid = false
            }

            if let licenseNumber = model.licenseNumber, licenseNumber.isEmpty {
                licenseNumberErrorMessage = "الحقل مطلوب"
                isValid = false
            } else if let licenseNumber = model.licenseNumber, Int(licenseNumber) == nil {
                licenseNumberErrorMessage = "يرجى إدخال رقم ترخيص صالح (أرقام فقط)."
                isValid = false
            }
        }
        
        
        if isValid {
//            successMessage = "🥳تم إنشاء الحساب بنجاح!"
            successMessage = "تم إنشاء حساب \(model.userType == .patient ? "المريض" : "الدكتور") بنجاح🥳"

            
        }
        
        return isValid
    }
    
    // تحقق شاشة كلمة سر جديدة
    func validateNewPassword() -> Bool {
        
        clearErrors()
        
        var isValid = true
   
        if model.password.isEmpty {
            passwordErrorMessage = "الحقل مطلوب"
            isValid = false
        }
        
        else if model.password.count < 6 {
            passwordErrorMessage = "يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل."
            isValid = false
        }
        
        if model.confirmPassword != model.password {
            confirmPasswordErrorMessage = "كلمة المرور وتأكيدها غير متطابقين."
            isValid = false
        }
        
        if isValid {
            successMessage = "تم تعديل كلمة السر بنجاح🥳"
        }
        
        return isValid
        
    }
    
    // تحقق شاشة استعادة كلمة السر
    func validateResetPassword() -> Bool {
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
            successMessage = "تم إرسال رابط استعادة كلمة المرور بنجاح👍🏻"
        }
        
        return isValid
}
    
    // تحقق من رمز otp
    func validateOtp() -> Bool {
        clearErrors()
        var isValid = true
        
//        if  Int(otpCode) == nil {
//            otpErrorMessage = "يرجى إدخال رمز otp صحيح"
//            isValid = false
//        }
            if otpCode.isEmpty {
            otpErrorMessage = "يرجى إدخال الرمز"
            isValid = false
            }
            else if otpCode != defaultOtp {
            otpErrorMessage = "رمز OTP غير صحيح."
            isValid = false
        }
        
        if isValid {
            successMessage = "تم التحقق بنجاح👍🏻"
        }
        
        return isValid
    }
    
    // تفريغ جميع الرسائل
    func clearErrors() {
        specializationErrorMessage = ""
        licenseNumberErrorMessage = ""
        emailErrorMessage = ""
        passwordErrorMessage = ""
        fullNameErrorMessage = ""
        confirmPasswordErrorMessage = ""
        otpErrorMessage = ""
    }
    }
    
