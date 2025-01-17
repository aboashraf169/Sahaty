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

    var body: some View {
        VStack {
            Text("Loading...")
                .onAppear {
                    if SessionManager.shared.isUserLoggedIn() {
                        if let userType = SessionManager.shared.getUserType() {
                            if userType == .doctor {
                                navigateToDoctor = true
                            } else {
                                navigateToPatient = true
                            }
                        }
                    } else {
                        navigateToLogin = true
                    }
                }
        }
        .navigationDestination(isPresented: $navigateToDoctor) {
            DoctorTabBarView()
        }
        .navigationDestination(isPresented: $navigateToPatient) {
            PatientTabBarView(Patient: PatiantModel(id: 0, fullName: "", email: ""))
        }
        .navigationDestination(isPresented: $navigateToLogin) {
            LoginView()
        }
    }
}
