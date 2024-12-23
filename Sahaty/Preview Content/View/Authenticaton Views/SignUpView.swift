import SwiftUI


struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()
    @State private var showLoginView = false
    @State private var isSuccessAlertPresented = false

    var body: some View {
        NavigationStack {
            VStack {
                // Header
                headerView()

                // User Type Picker
                userTypePicker()

                ScrollView {
                    VStack(spacing: 20) {
                        sharedFields()
                        if signUpViewModel.model.userType == .doctor {
                            doctorFields()
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // Footer
                footerView()
            }
            .padding(.vertical, 20)
            .alert(signUpViewModel.signUpSuccessMessage, isPresented: $isSuccessAlertPresented) {
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
            CustomFieldView(
                label: "الاسم",
                placeholder: "أدخل الاسم كاملاً",
                text: $signUpViewModel.model.fullName,
                errorMessage: signUpViewModel.fullNameErrorMessage
            )

            CustomFieldView(
                label: "البريد الإلكتروني",
                placeholder: "أدخل عنوان بريدك الإلكتروني",
                text: $signUpViewModel.model.email,
                errorMessage: signUpViewModel.emailErrorMessage
            )

            PasswordField(
                password: $signUpViewModel.model.password,
                placeholder: "أدخل كلمة المرور",
                label: "كلمة المرور"
            )
            .padding(.top, 10)
            .overlay(errorMessageView(signUpViewModel.passwordErrorMessage))

            PasswordField(
                password: Binding(
                    get: { signUpViewModel.model.confirmPassword },
                    set: { signUpViewModel.model.confirmPassword = $0.isEmpty ? "" : $0 }
                ),
                placeholder: "تأكيد كلمة المرور",
                label: "تأكيد كلمة المرور"
            )
            .padding(.top, 10)
            .overlay(errorMessageView(signUpViewModel.confirmPasswordErrorMessage))
        }
    }

    // MARK: - Doctor Fields
    private func doctorFields() -> some View {
        Group {
            CustomFieldView(
                label: "التخصص",
                placeholder: "أدخل التخصص",
                text: Binding(
                    get: { signUpViewModel.model.specialization ?? "" },
                    set: { signUpViewModel.model.specialization = $0.isEmpty ? nil : $0 }
                ),
                errorMessage: signUpViewModel.specializationErrorMessage
            )

            CustomFieldView(
                label: "رقم التخصص الوظيفي",
                placeholder: "أدخل رقم التخصص الوظيفي",
                text: Binding(
                    get: { signUpViewModel.model.licenseNumber ?? "" },
                    set: { signUpViewModel.model.licenseNumber = $0.isEmpty ? nil : $0 }
                ),
                errorMessage: signUpViewModel.licenseNumberErrorMessage
            )
        }
    }

    // MARK: - Footer
    private func footerView() -> some View {
        Button(action: {
            if signUpViewModel.validateSignUp() {
                isSuccessAlertPresented = true
            }
        }) {
            Text("إنشاء الحساب")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .cornerRadius(10)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Error Message View
    private func errorMessageView(_ message: String) -> some View {
        Text(message)
            .font(.caption)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Custom Field View
struct CustomFieldView: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let errorMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .font(.callout)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(height: 45)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// MARK: - Preview
#Preview{
    SignUpView()
}
