//
//  DoctorDashboardView.swift
//  Sahaty
//
//  Created by mido mj on 12/10/24.
//


import SwiftUI
// واجهة قيد الانشاء
struct DoctorDashboardView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("لوحة التحكم للطبيب")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                Text("مرحبًا بك في تطبيق صحتي❤️")
                    .font(.title2)
                    .foregroundColor(.gray)

            }
            .padding(.bottom,200)
        }
    }
}

#Preview{
    DoctorDashboardView()
}
