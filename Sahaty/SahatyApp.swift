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
    
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }

}



extension View {
    func direction(_ language: String) -> some View {
        self.environment(\.layoutDirection, language == "ar" ? .rightToLeft : .leftToRight)
    }
}
extension String {
    func localized() -> String {
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
