import SwiftUI


struct NewPassworView: View {
    
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @State private var ShowLoginView = false
    @State private var isSuccessAlertPresented = false
    @State private var ShowAleartLoginView = false
    
// MARK: - View
    
    var body: some View {
        NavigationStack {
            VStack{
                
                // العنوان والوصف
                VStack(alignment: .trailing, spacing: 8) {
                  Text("قم بادخال كلمة المرور الجديدة")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 20)
                .padding(.top, 100)
                
                
                // كلمة المرور
                PasswordField(
                    password: $authenticationViewModel.model.password,
                    placeholder: "أدخل كلمة المرور",
                    label: "كلمة المرور"
                )
                .padding(.horizontal,20)
                .padding(.top,20)
                
                // رسالة الخطأ
                if !authenticationViewModel.passwordErrorMessage.isEmpty {
                    Text(authenticationViewModel.passwordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                

                // تأكيد كلمة المرور
                PasswordField(
                    password: Binding(
                        get: { authenticationViewModel.model.confirmPassword ?? "" },
                        set: { authenticationViewModel.model.confirmPassword = $0.isEmpty ? nil : $0 }
                    ),
                    placeholder: "تأكيد كلمة المرور",
                    label: "تأكيد كلمة المرور"
                )
                .padding(.horizontal,20)
                .padding(.top,20)
                
                // رسالة الخطأ
                if !authenticationViewModel.confirmPasswordErrorMessage.isEmpty {
                    Text(authenticationViewModel.confirmPasswordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                // زر تسجيل الدخول
                Button(action: {
                    if authenticationViewModel.validateNewPassword() {
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
                .padding(.top,40)
                
                // لاظهار رسالة نجاح
                .alert(authenticationViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                    Button("موافق", role: .cancel) {
                        ShowLoginView = true
                    }
                }
                .navigationDestination(isPresented: $ShowLoginView) {
                    LoginView()
                }
        
                Spacer()
            }
            
        }
    }
}

// MARK: - Preview
#Preview {
    NewPassworView()
}
