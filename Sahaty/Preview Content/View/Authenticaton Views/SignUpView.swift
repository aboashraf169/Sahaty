import SwiftUI

struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()
    @State private var showLoginView = false
    @State private var isSuccessAlertPresented = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                headerView()
                
                // MARK: - User Type Picker
                userTypePicker()
                
                ScrollView {
                    // MARK: - Center
                    VStack {
                        sharedFields()
                        
                        if signUpViewModel.model.userType == .doctor {
                            doctorFields()
                        }
                    }
                }
                
                // MARK: - Footer
                footerView()
            }
            .padding(.vertical, 20)
            .alert(signUpViewModel.successMessage.localized(), isPresented: $isSuccessAlertPresented) {
                Button("ok".localized(), role: .cancel) {
                    showLoginView = true
                }
            }
            .navigationDestination(isPresented: $showLoginView) {
                LoginView()
            }
            .direction(appLanguage) // اتجاه النصوص
            .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة
        }
    }
    
    // MARK: - Header
    private func headerView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("signup_subtitle".localized()) // بادر بالتسجيل
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("signup_title".localized()) // تسجيل جديد
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
    }
    
    // MARK: - User Type Picker
    private func userTypePicker() -> some View {
        Picker("user_type".localized(), selection: $signUpViewModel.model.userType) {
            Text("patient".localized()).tag(UserType.patient)
            Text("doctor".localized()).tag(UserType.doctor)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 20)
    }
    
    // MARK: - Shared Fields
    private func sharedFields() -> some View {
        Group {
            // الاسم
            fieldView(label: "name".localized(), placeholder: "enter_full_name".localized(), text: $signUpViewModel.model.fullName)
                .padding(.top, 20)
            
            errorMessageView(signUpViewModel.fullNameErrorMessage)
            
            // البريد الإلكتروني
            fieldView(label: "email".localized(), placeholder: "enter_email".localized(), text: $signUpViewModel.model.email)
                .padding(.top, 10)
            
            errorMessageView(signUpViewModel.emailErrorMessage)
            
            // كلمة المرور
            PasswordField(password: $signUpViewModel.model.password, placeholder: "enter_password".localized(), label: "password".localized())
            
            errorMessageView(signUpViewModel.passwordErrorMessage)
            
            // تأكيد كلمة المرور
            PasswordField(
                password: Binding(
                    get: { signUpViewModel.model.confirmPassword },
                    set: { signUpViewModel.model.confirmPassword = $0.isEmpty ? "" : $0 }
                ),
                placeholder: "confirm_password".localized(),
                label: "confirm_password_label".localized()
            )
            .padding(.top, 10)
            
            errorMessageView(signUpViewModel.passwordErrorMessage)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Doctor Fields
    private func doctorFields() -> some View {
        Group {
            fieldView(
                label: "specialization".localized(),
                placeholder: "enter_specialization".localized(),
                text: Binding(
                    get: { signUpViewModel.model.specialization ?? "" },
                    set: { signUpViewModel.model.specialization = $0.isEmpty ? nil : $0 }
                )
            )
            
            errorMessageView(signUpViewModel.specializationErrorMessage)
            
            fieldView(
                label: "license_number".localized(),
                placeholder: "enter_license_number".localized(),
                text: Binding(
                    get: { signUpViewModel.model.licenseNumber ?? "" },
                    set: { signUpViewModel.model.licenseNumber = $0.isEmpty ? nil : $0 }
                )
            )
            .padding(.top, 10)
            
            errorMessageView(signUpViewModel.licenseNumberErrorMessage)
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Footer
    private func footerView() -> some View {
        VStack {
            Button(action: {
                if signUpViewModel.validateSignUp() {
                    isSuccessAlertPresented = true
                }
            }) {
                Text("signup_button".localized()) // إنشاء الحساب
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Field View
    private func fieldView(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: text)
                .font(.callout)
                .padding()
                .background(Color(.systemGray6))
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .cornerRadius(10)
                .multilineTextAlignment(.leading)
        }
    }
    
    // MARK: - Error Message View
    @ViewBuilder
    private func errorMessageView(_ message: String) -> some View {
        if message.isEmpty {
            EmptyView()
        } else {
            Text(message)
                .font(.caption)
                .foregroundColor(.red)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Preview
#Preview {
    SignUpView()
}
