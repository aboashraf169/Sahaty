import Combine
import SwiftUI

class DoctorProfileViewModel: ObservableObject {
    
    @Published var doctor: DoctorModel = DoctorModel(
        id: 0,
        name: "Default Name",
        email: "default@example.com",
        isDoctor: 0,
        jobSpecialtyNumber: 0000,
        bio: "مثال",
        specialties: []
    )
    @Published var isSaveEnabled: Bool = false
    @Published var isLoading: Bool = false // لمعرفة حالة التحميل
    @Published var errorMessage: String? // رسائل الأخطاء
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadDoctorFromCoreData()
    }

    // MARK: - Save Doctor Data
    func loadDoctorFromCoreData() {
        if let savedDoctor = CoreDataManager.shared.fetchDoctor() {
            self.doctor = savedDoctor
            print("Doctor data loaded from Core Data")
        } else {
            print("No doctor data found in Core Data")
        }
    }

}
