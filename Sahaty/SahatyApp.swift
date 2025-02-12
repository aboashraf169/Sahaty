//
//  SahatyApp.swift
//  Sahaty
//
//  Created by mido mj on 12/5/24.
//

import SwiftUI
import Foundation

@main
struct SahatyApp: App {
//    @State private var isUserLoggedIn = SessionManager.shared.isUserLoggedIn()
//    @State private var userType = SessionManager.shared.getUserType()
    @StateObject private var doctorProfileViewModel = DoctorProfileViewModel()
    @StateObject private var patientViewModel = PatientSettingViewModel()
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    
    var body: some Scene {
        WindowGroup {
//            if isUserLoggedIn {
//                if userType == .doctor {
//                    DoctorTabBarView(doctorProfileViewModel: doctorProfileViewModel)
//                } else {
//                    PatientTabBarView(patientViewModel: patientViewModel)
//                    
//                }
//            } else {
                LoginView()
//            
//
//
//            }
        }
    }

}

extension View {
    // تحويل اتجاه النص حسب اتجاة اللغة
    func direction(_ language: String) -> some View {
        self.environment(\.layoutDirection, language == "ar" ? .rightToLeft : .leftToRight)
    }
}
extension String {
    func localized() -> String {
        
        // في حال لا توجد قيمه يتم اعطائه اللغة العربية اللغة الافتراضية
        if  UserDefaults.standard.string(forKey: "appLanguage") == nil {
            UserDefaults.standard.set("ar", forKey: "appLanguage")
        }
        guard let appLanguage = UserDefaults.standard.string(forKey: "appLanguage") else {
            return NSLocalizedString(self, comment: "")
        }
        
        guard let path = Bundle.main.path(forResource: appLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
}
