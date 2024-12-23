//
//  ProfileViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//


import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var doctor: DoctorModel
    @Published var articles: [ArticalModel] = []
    @Published var advices: [AdviceModel] = [] 

    init(doctor: DoctorModel) {
        self.doctor = doctor
        fetchDoctorArticles()
        fetchDoctorAdvice()
    }
    private func fetchDoctorArticles() {
        articles = [
            ArticalModel(
                description: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن.",
                authorId: doctor,
                publishDate: Date(),
                imagePost: "post"
            ),
            ArticalModel(
                description: "التغذية السليمة تعزز من صحة الجسم وتقي من الأمراض المزمنة.",
                authorId: doctor,
                publishDate: Date(),
                imagePost: nil
            )
        ]
    }

    
    
    private func fetchDoctorAdvice() {
        // بيانات النصائح الافتراضية الخاصة بالطبيب
        advices = [
            AdviceModel(
                content: "تناول وجبة إفطار صحية كل يوم لتحصل على بداية يوم مليئة بالطاقة.",
                authorId: doctor.user.id,
                publishDate: Date()
            ),
            AdviceModel(
                content: "مارس التمارين الرياضية بانتظام لتحسين لياقتك البدنية.",
                authorId: doctor.user.id,
                publishDate: Date()
            ),
            AdviceModel(
                content: "تناول وجبة إفطار صحية كل يوم لتحصل على بداية يوم مليئة بالطاقة.",
                authorId: doctor.user.id,
                publishDate: Date()
            ),
            AdviceModel(
                content: "مارس التمارين الرياضية بانتظام لتحسين لياقتك البدنية.",
                authorId: doctor.user.id,
                publishDate: Date()
            ),
            AdviceModel(
                content: "تناول وجبة إفطار صحية كل يوم لتحصل على بداية يوم مليئة بالطاقة.",
                authorId: doctor.user.id,
                publishDate: Date()
            ),
            AdviceModel(
                content: "مارس التمارين الرياضية بانتظام لتحسين لياقتك البدنية.",
                authorId: doctor.user.id,
                publishDate: Date()
            )
        ]
    }

}

