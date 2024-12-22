//
//  AdviceViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//
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
    
    // الطبيب المسؤول عن النصائح
    var currentUser: CommentAuthor? // المستخدم الحالي (Doctor أو Patient)
    var author: DoctorModel? // المؤلف (إذا كان Doctor)
    // MARK: - Initialization
    init(author: DoctorModel? = nil, currentUser: CommentAuthor? = nil) {
        // قم بتعيين القيم الافتراضية
        self.author = author
        if let doctor = author {
            self.currentUser = .doctor(doctor)
        } else {
            self.currentUser = currentUser
        }
//        if case .patient = currentUser {
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
//            }
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

    // MARK: - Add Advice
    func addAdvice() {
        clearError()
        let trimmedAdvice = newAdviceText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // التحقق من أن النصيحة ليست فارغة
        guard !trimmedAdvice.isEmpty else {
            errorMessage = "النصيحة لا يمكن أن تكون فارغة."
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
