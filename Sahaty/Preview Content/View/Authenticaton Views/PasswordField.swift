//
//  PasswordField.swift
//  Sahaty
//
//  Created by mido mj on 12/23/24.
//

import SwiftUI

// الهدف منه عند اضافة رمز اظهار كلمة المرور يتم اظهارها والعكس

struct PasswordField: View {
    @Binding var password: String
    @State private var isSecure: Bool = true
    var placeholder: String
    var label: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)

            HStack {
                if isSecure {
                    SecureField(placeholder, text: $password)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .multilineTextAlignment(.trailing) // لضبط الاتجاه مع اللغة
                } else {
                    TextField(placeholder, text: $password)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .multilineTextAlignment(.trailing)
                }

                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.top, 10)
    }
}
