import SwiftUI


    struct SignUpView: View {
        @StateObject private var signUpViewModel = SignUpViewModel()
        @State private var showLoginView = false
        @State private var isSuccessAlertPresented = false
        
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
                .alert(signUpViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                    Button("موافق", role: .cancel) {
                        showLoginView = true
                    }
                }
                .navigationDestination(isPresented: $showLoginView) {
                    LoginView()
                }
            }
        }
        
        // MARK: - Header
        private func headerView() -> some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("بادر بالتسجيل")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("تسجيل جديد")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color.accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
        }
        
        // MARK: - User Type Picker
        private func userTypePicker() -> some View {
            Picker("نوع المستخدم", selection: $signUpViewModel.model.userType) {
                Text("مريض").tag(UserType.patient)
                Text("طبيب").tag(UserType.doctor)
             
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
        }
        
        // MARK: - Shared Fields
        private func sharedFields() -> some View {
            Group {
                // الاسم
                fieldView(label: "الاسم", placeholder: "أدخل الاسم كاملاً", text: $signUpViewModel.model.fullName)
                    .padding(.top, 20)
                
                errorMessageView(signUpViewModel.fullNameErrorMessage)
                
                // البريد الإلكتروني
                fieldView(label: "البريد الإلكتروني", placeholder: "أدخل عنوان بريدك الإلكتروني..", text: $signUpViewModel.model.email)
                    .padding(.top, 10)
                
                errorMessageView(signUpViewModel.emailErrorMessage)
                
                // كلمة المرور
                PasswordField(password: $signUpViewModel.model.password, placeholder: "أدخل كلمة المرور", label: "كلمة المرور")
                
                errorMessageView(signUpViewModel.passwordErrorMessage)
                
                // تأكيد كلمة المرور
                PasswordField(
                    password: Binding(
                        get: { signUpViewModel.model.confirmPassword },
                        set: { signUpViewModel.model.confirmPassword = $0.isEmpty ? "" : $0 }
                    ),
                    placeholder: "تأكيد كلمة المرور",
                    label: "تأكيد كلمة المرور"
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
                    label: "التخصص",
                    placeholder: "أدخل التخصص",
                    text: Binding(
                        get: { signUpViewModel.model.specialization ?? "" },
                        set: { signUpViewModel.model.specialization = $0.isEmpty ? nil : $0 }
                    )
                )
                
                errorMessageView(signUpViewModel.specializationErrorMessage)
                
                fieldView(
                    label: "رقم التخصص الوظيفي",
                    placeholder: "أدخل رقم التخصص الوظيفي",
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
                    Text("أنشاء الحساب")
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
                EmptyView() // إرجاع EmptyView إذا كانت الرسالة فارغة
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
#Preview{
    SignUpView()
}
