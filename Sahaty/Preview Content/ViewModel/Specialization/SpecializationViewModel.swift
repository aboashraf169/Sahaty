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
        // بيانات افتراضية
        specializations = [
            Specialization(
                name: "طب الأطفال",
                doctors: [
                    DoctorModel(fullName: "محمد", email: "abo.ashraf@gmail.com", password: "123456789", specialization: "طب الأطفال", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "احمد", email: "mido.ashraf@gmail.com", password: "123456789", specialization: "طب الأطفال", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "عيسى", email: "abo.ashraf@gmail.com", password: "123456789", specialization: "طب الأطفال", licenseNumber: "55664321",profilePicture: "doctor", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "ماجد", email: "mido.ashraf@gmail.com", password: "123456789", specialization: "طب الأطفال", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: [])
    
                ]
            ),
            Specialization(
                name: "طب القلب",
                doctors: [
                    DoctorModel(fullName: "عبد الله", email: "abo.ashraf@gmail.com", password: "123456789", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "حسن", email: "mido.ashraf@gmail.com", password: "123456789", specialization:  "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "حاتم", email: "abo.ashraf@gmail.com", password: "123456789", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "مهدي", email: "mido.ashraf@gmail.com", password: "123456789", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: [])
    
                ]
            ),
            Specialization(
                name: "طب العيون",
                doctors: [
                    DoctorModel(fullName: "رشدي", email: "abo.ashraf@gmail.com", password: "123456789", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "خليل", email: "mido.ashraf@gmail.com", password: "123456789", specialization:  "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "خالد", email: "abo.ashraf@gmail.com", password: "123456789", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: []),
                    DoctorModel(fullName: "منصور", email: "mido.ashraf@gmail.com", password: "123456789", specialization: "طب القلب", licenseNumber: "55664321", articlesCount: 32, advicesCount: 32, followersCount: 35, articles: [], advices: [], comments: [], likedArticles: [])
    
                ]
            )
        ]
    }
    
    func filteredSpecializations(searchText: String) -> [Specialization] {
        if searchText.isEmpty {
            return specializations
        } else {
            return specializations.map { specialization in
                let filteredDoctors = specialization.doctors.filter {
                    $0.fullName.contains(searchText) || $0.specialization.contains(searchText)
                }
                return Specialization(name: specialization.name, doctors: filteredDoctors)
            }.filter { !$0.doctors.isEmpty }
        }
    }
}
