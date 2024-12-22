import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var resetPasswordViewModel = ResetPasswordViewModel()
    @State private var isSuccessAlertPresented = false
    @State private var showOtpVerificationScreen = false

    var userType: UserType // استلام نوع المستخدم (مريض أو طبيب)

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("نسيت كلمة المرور")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)

                    Text("سوف نرسل رمز لإعادة تعيين كلمة المرور")
                        .font(.body)
                        .foregroundColor(Color.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 140)

                // MARK: - Email Field
                VStack(alignment: .trailing, spacing: 5) {
                    Text("البريد الإلكتروني")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TextField("أدخل عنوان بريدك الإلكتروني..", text: $resetPasswordViewModel.model.email)
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
                    Text("إرسال")
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
                Button("موافق", role: .cancel) {
                    showOtpVerificationScreen = true
                }
            }
            .navigationDestination(isPresented: $showOtpVerificationScreen) {
                OtpVerificationView()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ForgotPasswordView(userType: .patient)
}
