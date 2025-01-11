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
                description: "article_1".localized(),
                name: doctor.fullName,
                userName: "@\(doctor.fullName.replacingOccurrences(of: " ", with: "").lowercased())",
                addTime: "2_hours_ago".localized(),
                imagePost: "post",
                personImage: doctor.profilePicture,
                comments: []
            ),
            ArticalModel(
                description: "article_2".localized(),
                name: doctor.fullName,
                userName: "@\(doctor.fullName.replacingOccurrences(of: " ", with: "").lowercased())",
                addTime: "3_hours_ago".localized(),
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
        // بيانات النصائح الافتراضية الخاصة بالطبيب
        advices = [
            AdviceModel(
                content: "advice_1".localized(),
                authorName: "د. علي سالم",
                publishDate: Date()
            ),
            AdviceModel(
                content: "advice_2".localized(),
                authorName: "د. مريم عبد الله",
                publishDate: Date()
            ),
            AdviceModel(
                content: "advice_1".localized(),
                authorName: "د. علي سالم",
                publishDate: Date()
            ),
            AdviceModel(
                content: "advice_2".localized(),
                authorName: "د. مريم عبد الله",
                publishDate: Date()
            )
        ]
    }
}
