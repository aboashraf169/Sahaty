//
//  changePasswordView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct changePasswordView: View {
    var usersType: UsersType // نوع المستخدم
    @StateObject private var newPasswordViewModel = NewPasswordViewModel(token: "")
    @State private var isSuccessAlertPresented = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        
        VStack{
            HStack {
                Text("change_password".localized())
                .font(.title)
                Spacer()
            }
            .padding(.vertical)
            
            // MARK: - Old Password Field
    
            VStack{
//                PasswordField(
//                    password: Binding(
//                        get: { newPasswordViewModel.model.oldPassword ?? ""},
//                        set: { newPasswordViewModel.model.oldPassword = $0.isEmpty ? nil : $0}
//                    ),
//                    placeholder: "enter_old_password".localized(),
//                    label: "old_password".localized()
//                )
//                
        
                
            }


            // MARK: - New Password Field
            VStack{
                PasswordField(
                    password: $newPasswordViewModel.model.password,
                    placeholder: "enter_password".localized(),
                    label: "password".localized()
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
                    password: $newPasswordViewModel.model.confirmPassword,
                    placeholder: "confirm_password".localized(),
                    label: "confirm_password_label".localized()
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
                Text("confirm".localized())
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
                Button("ok", role: .cancel) {
                }
            }
            
            Spacer()
            
        }
        .padding()
        .direction(appLanguage) // ضبط اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط البيئة
    
  
            
        
    }
}

#Preview {
    changePasswordView(usersType: .doctor)
}
