//
//  ProfileViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//


import Foundation

class PatientProfileViewModel: ObservableObject {
    
    @Published var patient: PatientModel
    @Published var isSaveEnabled: Bool = false

    @Published var userProfile = PatientModel(fullName: "محمود اسماعيل", email: "hamada@gmail.com", followedDoctors: [], favoriteArticles: [], favoriteAdvices: [], likedArticles: [], articleComments: [])
    init(patient: PatientModel) {
        self.patient = patient
        validateFields()

    }
    
    func validateFields() {
        isSaveEnabled = !userProfile.fullName.isEmpty &&
                        !userProfile.email.isEmpty &&
                        !(userProfile.age == nil)
    }

    
    func saveChanges() {
        print("Profile saved: \(userProfile)")
    }

}
    
    

