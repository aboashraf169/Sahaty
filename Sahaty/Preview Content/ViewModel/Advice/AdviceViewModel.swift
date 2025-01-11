import Foundation
import SwiftUI
import Combine

class AdviceViewModel: ObservableObject {
    // MARK: - Properties
    @Published var advices: [AdviceModel] = [] // قائمة النصائح
    @Published var newAdviceText: String = "" // النص الجديد للنصيحة
    @Published var editingAdvice: AdviceModel? // النصيحة التي يتم تعديلها
    @Published var errorMessage: String? // رسالة الخطأ
    @Published var filteredAdvices: [AdviceModel] = [] // النصائح المفلترة بناءً على البحث
    @Published var searchText: String = "" // النص المدخل في البحث
    private var cancellables = Set<AnyCancellable>()
    
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }

    // الطبيب المسؤول عن النصائح
    var currentUser: CommentAuthor? // المستخدم الحالي (Doctor أو Patient)
    var author: DoctorModel? // المؤلف (إذا كان Doctor)

    // MARK: - Initialization
    init(author: DoctorModel? = nil, currentUser: CommentAuthor? = nil) {
        self.author = author
        if let doctor = author {
            self.currentUser = .doctor(doctor)
        } else {
            self.currentUser = currentUser
        }
        addDefaultAdvicesForPatient() // إضافة بيانات افتراضية إذا كان المستخدم مريضًا
        filteredAdvices = advices

        // ربط النص المدخل مع التصفية
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main) // تأخير التحديث لتقليل عمليات التصفية
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterAdvices(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Add filter Advices
    // تصفية النصائح
    private func filterAdvices(with searchText: String) {
        if searchText.isEmpty {
            filteredAdvices = advices
        } else {
            filteredAdvices = advices.filter { $0.content.localizedCaseInsensitiveContains(searchText) }
        }
    }

    // MARK: - Add Default Advices
    private func addDefaultAdvicesForPatient() {
        advices = [
            AdviceModel(
                content: "default_advice_1".localized(),
                authorName: "default_author_1".localized(),
                publishDate: Date()
            ),
            AdviceModel(
                content: "default_advice_2".localized(),
                authorName: "default_author_2".localized(),
                publishDate: Date()
            )
        ]
    }

    // MARK: - Add Advice
    func addAdvice() {
        clearError()
        let trimmedAdvice = newAdviceText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // التحقق من أن النصيحة ليست فارغة
        guard !trimmedAdvice.isEmpty else {
            errorMessage = "empty_advice_error".localized()
            return
        }
        
        // التحقق من حالة التعديل أو الإضافة
        if let editingIndex = advices.firstIndex(where: { $0.id == editingAdvice?.id }) {
            // تحديث النصيحة الحالية
            advices[editingIndex].content = trimmedAdvice
            editingAdvice = nil
        } else {
            // إضافة نصيحة جديدة
            if let authorName = author?.fullName {
                let newAdvice = AdviceModel(
                    content: trimmedAdvice,
                    authorName: authorName,
                    publishDate: Date()
                )
                advices.append(newAdvice)
            } else {
                print("Error: Author name is not set.")
            }
        }
        
        // إعادة ضبط الحقول
        newAdviceText = ""
    }

    // MARK: - Delete Advice
    func deleteAdvice(at indexSet: IndexSet) {
        advices.remove(atOffsets: indexSet)
    }
    
    // MARK: - Clear Editing
    // إعادة ضبط حقول التعديل
    func clearEditing() {
        editingAdvice = nil
        newAdviceText = ""
    }
    
    // MARK: - Move Advice
    // إعادة ترتيب النصائح
    func moveAdvice(from source: IndexSet, to destination: Int) {
        advices.move(fromOffsets: source, toOffset: destination)
    }
    
    // MARK: - Start Editing
    func startEditing(advice: AdviceModel) {
        editingAdvice = advice
        newAdviceText = advice.content // تعبئة النص الحالي في الحقل
    }
    
    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}
