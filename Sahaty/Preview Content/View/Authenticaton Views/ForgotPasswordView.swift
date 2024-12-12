import SwiftUI

struct ForgotPasswordView: View {
    
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @State private var isSuccessAlertPresented = false
    @State private var ShowOtpverifiedScreen = false
    
    var userType: UserType // استلام نوع المستخدم (مريض أو طبيب)
    
    
    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack{
                // العنوان الرئيسي والوصف
                VStack(alignment: .trailing, spacing: 8) {
                    Text("نسيت كلمة المرور")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                    
                    Text("سوف نرسل رمز لإعادة تعيين كلمة المرور")
                        .font(.body)
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.trailing)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                // محاذاة النص إلى اليمين
                .padding(.horizontal, 20)
                .padding(.top, 140)
                
                
                // حقل البريد الإلكتروني
                VStack(alignment: .leading, spacing: 5) {
                    Text("البريد الإلكتروني")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.trailing, 20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    TextField("أدخل عنوان بريدك الإلكتروني..", text: $authenticationViewModel.model.email)
                        .padding()
                        .frame(height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .multilineTextAlignment(.trailing)
                        .padding(.horizontal, 20)
                }
                .padding(.top,20)
                if !authenticationViewModel.emailErrorMessage.isEmpty {
                    Text(authenticationViewModel.emailErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                // زر إرسال
                Button(action: {
                    if authenticationViewModel.validateResetPassword() {
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
                .padding(.top,20)
                .padding(.horizontal, 20)
                Spacer()
            }
            .alert(authenticationViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                Button("موافق", role: .cancel) {
                    ShowOtpverifiedScreen = true
                }
            }
            .navigationDestination(isPresented: $ShowOtpverifiedScreen) {
                OtpVerificationView()
              }
        }
    }
}

// MARK: - Preview
#Preview{
    ForgotPasswordView(userType: .patient)

}
