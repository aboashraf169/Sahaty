//
//  changePasswordView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct changePasswordView: View {
    var userType: UserType // نوع المستخدم
    @StateObject private var newPasswordViewModel = NewPasswordViewModel()
    @State private var isSuccessAlertPresented = false

    var body: some View {
        
        VStack{
            HStack {
                Text("تغيير كلمة المرور")
                .font(.title)
                Spacer()
            }
            .padding(.vertical)
            
            // MARK: - Old Password Field
    
            VStack{
                PasswordField(
                    password: Binding(
                        get: { newPasswordViewModel.model.oldPassword ?? ""},
                        set: { newPasswordViewModel.model.oldPassword = $0.isEmpty ? nil : $0}
                    ),
                    placeholder: "أدخل كلمة القديمة",
                    label: "كلمة المرور القديمة"
                )
                
                
                
                // Error Message for Old Password
                if !newPasswordViewModel.OldPasswordErrorMessage.isEmpty {
                    Text(newPasswordViewModel.OldPasswordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                }
                
            }


            // MARK: - New Password Field
            VStack{
                PasswordField(
                    password: $newPasswordViewModel.model.password,
                    placeholder: "أدخل كلمة المرور",
                    label: "كلمة المرور"
                )

            // Error Message for Password
            if !newPasswordViewModel.passwordErrorMessage.isEmpty {
                Text(newPasswordViewModel.passwordErrorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

            }
            }
            .padding(.top)
    
            

            // MARK: - Confirm Password Field
            VStack{
                PasswordField(
                    password: Binding(
                        get: { newPasswordViewModel.model.confirmPassword ?? "" },
                        set: { newPasswordViewModel.model.confirmPassword = $0.isEmpty ? nil : $0 }
                    ),
                    placeholder: "تأكيد كلمة المرور",
                    label: "تأكيد كلمة المرور"
                )
            
            // Error Message for Confirm Password
            if !newPasswordViewModel.confirmPasswordErrorMessage.isEmpty {
                Text(newPasswordViewModel.confirmPasswordErrorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

            }
            }
            .padding(.top)
            
            // MARK: - Submit Button
            Button(action: {
                if newPasswordViewModel.validateNewPassword() {
                    isSuccessAlertPresented = true
                }
            }) {
                Text("تأكيد")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.top,30)
            
            // Success Alert
            .alert(newPasswordViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                Button("موافق", role: .cancel) {
                }
            }
            
            Spacer()
            
        }
        .padding()
  
            
        
    }
}

#Preview {
    changePasswordView(userType: .doctor)
}
