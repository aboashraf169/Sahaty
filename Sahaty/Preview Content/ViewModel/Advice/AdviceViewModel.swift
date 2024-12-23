//
//  AdviceViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//
import Foundation
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
    var author: DoctorModel? // الطبيب المسؤول عن النصائح

    // MARK: - Initialization
    init(author: DoctorModel? = nil) {
        self.author = author
        addDefaultAdvices()
        setupSearchFiltering()
    }

    // MARK: - Search Filtering
    private func setupSearchFiltering() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main) // تقليل التحديثات
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterAdvices(with: searchText)
            }
            .store(in: &cancellables)
    }

    private func filterAdvices(with searchText: String) {
        if searchText.isEmpty {
            filteredAdvices = advices
        } else {
            filteredAdvices = advices.filter {
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // MARK: - Add Default Advices
    private func addDefaultAdvices() {
        guard let authorId = author?.id else { return }
        advices = [
            AdviceModel(
                content: "تناول وجبة إفطار صحية كل يوم لتحصل على بداية يوم مليئة بالطاقة.",
                authorId: authorId,
                publishDate: Date()
            ),
            AdviceModel(
                content: "مارس التمارين الرياضية بانتظام لتحسين لياقتك البدنية.",
                authorId: authorId,
                publishDate: Date()
            )
        ]
        filteredAdvices = advices
    }

    // MARK: - Add Advice
    func addAdvice() {
        clearError()

        let trimmedAdvice = newAdviceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAdvice.isEmpty else {
            errorMessage = "النصيحة لا يمكن أن تكون فارغة."
            return
        }

        guard let authorId = author?.id else {
            errorMessage = "لا يمكن إضافة النصيحة بدون تعريف الطبيب."
            return
        }

        if let editingIndex = advices.firstIndex(where: { $0.id == editingAdvice?.id }) {
            // تحديث النصيحة الحالية
            advices[editingIndex].content = trimmedAdvice
            editingAdvice = nil
        } else {
            // إضافة نصيحة جديدة
            let newAdvice = AdviceModel(
                content: trimmedAdvice,
                authorId: authorId,
                publishDate: Date()
            )
            advices.append(newAdvice)
        }

        newAdviceText = ""
        filteredAdvices = advices
    }

    // MARK: - Delete Advice
    func deleteAdvice(at indexSet: IndexSet) {
        advices.remove(atOffsets: indexSet)
        filteredAdvices = advices
    }

    // MARK: - Start Editing
    func startEditing(advice: AdviceModel) {
        editingAdvice = advice
        newAdviceText = advice.content
    }

    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}
