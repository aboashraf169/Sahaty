//
//  SplashScreenView.swift
//  Sahaty
//
//  Created by mido mj on 1/14/25.
//

import SwiftUI
import Foundation

struct SplashScreenView: View {
    @State private var navigateToDoctor = false
    @State private var navigateToPatient = false
    @State private var navigateToLogin = false
    @StateObject private var loginViewModel = LoginViewModel()
    @ObservedObject var doctorProfileViewModel: DoctorProfileViewModel
    @ObservedObject var PatientViewModel: PatientSettingViewModel
    var body: some View {
        VStack {
            Text("Loading...")
//                .onAppear {
                    
//                    if SessionManager.shared.isUserLoggedIn() {
//                        if let userType = SessionManager.shared.getUserType() {
//                            if userType == .doctor {
//                                navigateToDoctor = true
//                            } else {
//                                navigateToPatient = true
//                            }
//                        }
//                    } else {
//                        navigateToLogin = true
//                    }
//                }
        }
        .navigationDestination(isPresented: $navigateToDoctor) {
            DoctorTabBarView(doctorProfileViewModel: doctorProfileViewModel)
        }
        .navigationDestination(isPresented: $navigateToPatient) {
            PatientTabBarView(patientViewModel: PatientViewModel)
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView()
        }
    }
}
