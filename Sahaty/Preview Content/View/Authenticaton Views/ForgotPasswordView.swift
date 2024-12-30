import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var resetPasswordViewModel = ResetPasswordViewModel()
    @State private var isSuccessAlertPresented = false
    @State private var showOtpVerificationScreen = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var userType: UserType // استلام نوع المستخدم (مريض أو طبيب)

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("forgot_password_title".localized()) // نسيت كلمة المرور
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)

                    Text("forgot_password_description".localized()) // سوف نرسل رمز لإعادة تعيين كلمة المرور
                        .font(.body)
                        .foregroundColor(Color.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 140)

                // MARK: - Email Field
                VStack(alignment: .trailing, spacing: 5) {
                    Text("email".localized()) // البريد الإلكتروني
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("enter_email".localized(), text: $resetPasswordViewModel.model.email) // أدخل عنوان بريدك الإلكتروني
                        .padding()
                        .frame(height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)

                // Error Message
                if !resetPasswordViewModel.emailErrorMessage.isEmpty {
                    Text(resetPasswordViewModel.emailErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // MARK: - Send Button
                Button(action: {
                    if resetPasswordViewModel.validateEmail() {
                        isSuccessAlertPresented = true
                    }
                }) {
                    Text("send".localized()) // إرسال
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)

                Spacer()
            }
            .alert(resetPasswordViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                Button("ok".localized(), role: .cancel) { // موافق
                    showOtpVerificationScreen = true
                }
            }
            .navigationDestination(isPresented: $showOtpVerificationScreen) {
                OtpVerificationView()
            }
        }
        .direction(appLanguage) // تطبيق الاتجاه
        .environment(\.locale, .init(identifier: appLanguage)) // تطبيق اللغة المختارة

    }
}

// MARK: - Preview
#Preview {
    ForgotPasswordView(userType: .patient)
}
