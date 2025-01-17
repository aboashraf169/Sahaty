//
//  PatientDashboardView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI

struct PatientTabBarView: View {
    @StateObject var appState = AppState()
    @State var Patient: PatiantModel
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        TabView(selection: $appState.selectedTabPatients) {
            // MARK: - Home Tab
            PatientHomeScreen(adviceViewModel: AdviceViewModel(), articlesViewModel: ArticalsViewModel())
                .tabItem {
                    HStack {
                        Text("home".localized()) // الرئيسية
                        Image(systemName: "house.fill")
                    }
                }
                .tag(TabPatient.home)

            // MARK: - Doctors Tab
            SpecializationsDoctorsView()
                .tabItem {
                    HStack {
                        Text("doctors".localized()) // الاطباء
                        Image(systemName: "person.2")
                    }
                }
                .tag(TabPatient.Doctors)

            // MARK: - Notifications Tab
            NotificationsView()
                .tabItem {
                    HStack {
                        Text("notifications".localized()) // الاشعارات
                        Image(systemName: "heart.fill")
                    }
                }
                .tag(TabPatient.Notificatons)
                .badge(5) // عدد الإشعارات

            // MARK: - Settings Tab
            PatientSettingView(viewModel: PatiantModel(id: 0, fullName: "mido", email: "mido@gmail.com"))
                .padding()
                .tabItem {
                    HStack {
                        Text("settings".localized()) // الاعدادات
                        Image(systemName: "gear")
                    }
                }
                .tag(TabPatient.settings)
        }
        .direction(appLanguage) // ضبط اتجاه النصوص
        .environmentObject(appState) // مشاركة حالة التطبيق مع جميع الشاشات
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة المختارة
    }
}

// MARK: - Preview
#Preview {
    PatientTabBarView(Patient: PatiantModel(id: 0, fullName: "mido", email: "asdvdsv@gmail.com"))
}


