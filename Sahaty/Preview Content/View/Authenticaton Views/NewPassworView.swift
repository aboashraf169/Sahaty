import SwiftUI

struct NewPasswordView: View {
    @StateObject private var newPasswordViewModel = NewPasswordViewModel()
    @State private var showLoginView = false
    @State private var isSuccessAlertPresented = false

    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("قم بادخال كلمة المرور الجديدة")
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
                    placeholder: "أدخل كلمة المرور",
                    label: "كلمة المرور"
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
                    placeholder: "تأكيد كلمة المرور",
                    label: "تأكيد كلمة المرور"
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
                    Text("تسجيل الدخول")
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
                    Button("موافق", role: .cancel) {
                        showLoginView = true
                    }
                }
                .navigationDestination(isPresented: $showLoginView) {
                    LoginView()
                }

                Spacer()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NewPasswordView()
}
