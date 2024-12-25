//
//  ProfileViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//


import Foundation

class DoctorProfileViewModel: ObservableObject {
    @Published var doctor: DoctorModel
    @Published var articles: [ArticalModel] = []
    @Published var advices: [AdviceModel] = []
    @Published var isSaveEnabled: Bool = false

    @Published var userProfile = DoctorModel(fullName: "محمد اشرف", email: "mido@gmail.com", specialization: "طب عيون", licenseNumber: "4656564934943", articlesCount: 0, advicesCount: 0, followersCount: 0, articles: [], advices: [], comments: [], likedArticles: [])

    
    init(doctor: DoctorModel) {
        self.doctor = doctor
        fetchDoctorArticles()
        fetchDoctorAdvice()
        validateFields()

    }
    
    func validateFields() {
        isSaveEnabled = !userProfile.fullName.isEmpty &&
                        !userProfile.email.isEmpty &&
                        !userProfile.specialization.isEmpty &&
        !userProfile.licenseNumber.isEmpty
    }
    private func fetchDoctorArticles() {
        // بيانات المقالات الافتراضية الخاصة بالطبيب
        articles = [
            ArticalModel(
                description: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.",
                name: doctor.fullName,
                userName: "@\(doctor.fullName.replacingOccurrences(of: " ", with: "").lowercased())",
                addTime: "منذ ساعتين",
                imagePost: "post",
                personImage: doctor.profilePicture,
                comments: []
            ),
            ArticalModel(
                description: "التغذية السليمة تعزز من صحة الجسم وتقي من الأمراض المزمنة.",
                name: doctor.fullName,
                userName: "@\(doctor.fullName.replacingOccurrences(of: " ", with: "").lowercased())",
                addTime: "منذ 3 ساعات",
                imagePost: nil,
                personImage: doctor.profilePicture,
                comments: []
            )
        ]
    }
    
    func saveChanges() {
        print("Profile saved: \(userProfile)")
    }

    
    private func fetchDoctorAdvice() {
        // بيانات المقالات الافتراضية الخاصة بالطبيب
      advices = [
            AdviceModel(
                content: "تناول وجبة إفطار صحية كل يوم لتحصل على بداية يوم مليئة بالطاقة.",
                authorName: "د. علي سالم",
                publishDate: Date()
            ),
            AdviceModel(
                content: "مارس التمارين الرياضية بانتظام لتحسين لياقتك البدنية.",
                authorName: "د. مريم عبد الله",
                publishDate: Date()
            ),
            AdviceModel(
                content: "تناول وجبة إفطار صحية كل يوم لتحصل على بداية يوم مليئة بالطاقة.",
                authorName: "د. علي سالم",
                publishDate: Date()
            ),
            AdviceModel(
                content: "مارس التمارين الرياضية بانتظام لتحسين لياقتك البدنية.",
                authorName: "د. مريم عبد الله",
                publishDate: Date()
            ),
            AdviceModel(
                content: "مارس التمارين الرياضية بانتظام لتحسين لياقتك البدنية.",
                authorName: "د. مريم عبد الله",
                publishDate: Date()
            ),
            AdviceModel(
                content: "تناول وجبة إفطار صحية كل يوم لتحصل على بداية يوم مليئة بالطاقة.",
                authorName: "د. علي سالم",
                publishDate: Date()
            ),
            AdviceModel(
                content: "مارس التمارين الرياضية بانتظام لتحسين لياقتك البدنية.",
                authorName: "د. مريم عبد الله",
                publishDate: Date()
            )
        ]
    }
    
    
    
}
