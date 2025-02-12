//
//  PatientSettingModelView.swift
//  Sahaty
//
//  Created by mido mj on 1/21/25.
//

import Foundation
import SwiftUI

struct responseFollowDoctor : Codable {
    let message: String
    let following: Bool
}

class PatientSettingViewModel : ObservableObject {
    
    @Published var patient = PatiantModel()
    @Published var doctorFollowers : [DoctorModel] = []
    @Published var spaclizationDctors : [DoctorModel] = []
    @Published var doctorsBySpecialization: [Int: [DoctorModel]] = [:] // تخزين الأطباء لكل تخصص
    @Published var expandedSpecializations: [Int: Bool] = [:]     // حالة التوسيع لكل تخصص
    @Published var isLoading : Bool = false
    @AppStorage("isDarkModePatient")  var isDarkModePatient = false // حفظ الاختيار
    
    // MARK: - Set Patient Data
    func SetPateintData(_ patient : PatiantModel){
        self.patient = patient
        
    }
    // MARK: - get doctor Follow data
    func getDoctorsFollowers(){
        self.isLoading = true
        APIManager.shared.sendRequest(endpoint: "/user/doctors", method: .get) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLoading = false
                switch result {
                case.success(let data):
                    guard let decodeData = try? JSONDecoder().decode([DoctorModel].self, from: data)else {
                        print("error to decode doctor follower data")
                        return
                    }
                    self?.doctorFollowers = decodeData
                    print("success to get followers doctors")
                case.failure(let error):
                    print("error to get followers doctors: \(error)")
                }
            }
        }
    }
    
    // MARK: -  get Speciaty Doctors data
    func getSpeciatyDoctors(speciatyid: Int){
       self.isLoading = true
       APIManager.shared.sendRequest(endpoint: "/speciaty/\(speciatyid)/doctors", method: .get) { result in
           DispatchQueue.main.async {[weak self] in
               self?.isLoading = false
               switch result {
               case.success(let data):
                   guard let decodeData = try? JSONDecoder().decode(ResponseSpeciatyDoctor.self, from: data)else {
                       print("error to decode doctor follower data")
                       return
                   }
                   self?.doctorsBySpecialization[speciatyid] = decodeData.data
                   print("success to get Speciaty Doctors doctors: \(speciatyid)")
               case .failure(let error) :
                   print("error to get data for spaclity:\(error)")
               }
           }
       }
        
    }
    
    // MARK: -  follow doctor
    
    func actionFollowDoctor(doctorId : Int) {
        self.isLoading = true
        
        APIManager.shared.sendRequest(endpoint: "/user/follow-doctor/5",method: .post) { result in
            DispatchQueue.main.async {[weak self] in
                self?.isLoading = false
                switch result {
                    case .success(let data):
                    guard let decodeData = try? JSONDecoder().decode(responseFollowDoctor.self, from: data) else {
                        print("error to decode action Follow Doctor data")
                        return
                    }
                    print("Doctor follower data: \(decodeData.message)")
                    case.failure(let error):
                    print("error to decode action Follow Doctor data: \(error)")

                }
            }
        }
        
    }


}
