import SwiftUI

struct NewPasswordView: View {
    @StateObject private var newPasswordViewModel = NewPasswordViewModel()
    @State private var showLoginView = false
    @State private var isSuccessAlertPresented = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("enter_new_password".localized()) // قم بادخال كلمة المرور الجديدة
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 100)

                // MARK: - Password Field
                PasswordField(
                    password: $newPasswordViewModel.model.password,
                    placeholder: "enter_password".localized(), // أدخل كلمة المرور
                    label: "password".localized() // كلمة المرور
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Error Message for Password
                if !newPasswordViewModel.passwordErrorMessage.isEmpty {
                    Text(newPasswordViewModel.passwordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // MARK: - Confirm Password Field
                PasswordField(
                    password: Binding(
                        get: { newPasswordViewModel.model.confirmPassword ?? "" },
                        set: { newPasswordViewModel.model.confirmPassword = $0.isEmpty ? nil : $0 }
                    ),
                    placeholder: "confirm_password".localized(), // تأكيد كلمة المرور
                    label: "confirm_password".localized() // تأكيد كلمة المرور
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Error Message for Confirm Password
                if !newPasswordViewModel.confirmPasswordErrorMessage.isEmpty {
                    Text(newPasswordViewModel.confirmPasswordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // MARK: - Submit Button
                Button(action: {
                    if newPasswordViewModel.validateNewPassword() {
                        isSuccessAlertPresented = true
                    }
                }) {
                    Text("login".localized()) // تسجيل الدخول
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)

                // Success Alert
                .alert(newPasswordViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                    Button("ok".localized(), role: .cancel) { // موافق
                        showLoginView = true
                    }
                }
                .navigationDestination(isPresented: $showLoginView) {
                    LoginView()
                }

                Spacer()
            }
        }
        .direction(appLanguage) // اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة
    }
}

// MARK: - Preview
#Preview {
    NewPasswordView()
}
