//
//  SpecializationViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/21/24.
//


import SwiftUI

class SpecializationViewModel: ObservableObject {
    @Published var specializations: [Specialization] = []

    init(){
//        // بيانات افتراضية
//        specializations = [
//            Specialization(
//                name: "طب الأطفال",
//                doctors: [
//                    DoctorModel(  id: "",fullName: "محمد", email: "abo.ashraf@gmail.com",specialization: "طب الأطفال", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(  id: "",fullName: "احمد", email: "mido.ashraf@gmail.com",specialization: "طب الأطفال", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(  id: "",fullName: "عيسى", email: "abo.ashraf@gmail.com",specialization: "طب الأطفال", licenseNumber: "55664321",profilePicture: "doctor", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(  id: "",fullName: "ماجد", email: "mido.ashraf@gmail.com",specialization: "طب الأطفال", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35)
//    
//                ]
//            ),
//            Specialization(
//                name: "طب القلب",
//                doctors: [
//                    DoctorModel(id: "",fullName: "عبد الله", email: "abo.ashraf@gmail.com",specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(id: "",fullName: "حسن", email: "mido.ashraf@gmail.com", specialization:  "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(id: "",fullName: "حاتم", email: "abo.ashraf@gmail.com", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(id: "",fullName: "مهدي", email: "mido.ashraf@gmail.com",specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35)
//    
//                ]
//            ),
//            Specialization(
//                name: "طب العيون",
//                doctors: [
//                    DoctorModel(id: "",fullName: "رشدي", email: "abo.ashraf@gmail.com", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(id: "",fullName: "خليل", email: "mido.ashraf@gmail.com",specialization:  "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(id: "",fullName: "خالد", email: "abo.ashraf@gmail.com", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35),
//                    DoctorModel(id: "",fullName: "منصور", email: "mido.ashraf@gmail.com",specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35)
//    
//                ]
//            )
//        ]
    }
    
//    func filteredSpecializations(searchText: String) -> [Specialization] {
//        if searchText.isEmpty {
//            return specializations
//        } else {
//            return specializations.map { specialization in
//                let filteredDoctors = specialization.doctors.filter {
//                    $0.name.contains(searchText) || $0.jobSpecialtyNumber.contains(searchText)
//                }
//                return Specialization(name: specialization.name, doctors: filteredDoctors)
//            }.filter { !$0.doctors.isEmpty }
//        }
//    }
}
