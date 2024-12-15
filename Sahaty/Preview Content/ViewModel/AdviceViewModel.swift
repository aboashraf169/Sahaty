//
//  AdviceViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//
import Foundation
class AdviceViewModel : ObservableObject {
    
    @Published var Advicies : [AdviceModel] = []
    @Published var newAdvice: String = ""
    @Published var editingAdvice: AdviceModel? // Track the advice being edited
    
//    AdviceModel(userName: "mido mj", title: "اشرب 8 أكواب ماء يوميًا للحفاظ على ترطيب جسمك"),
//    AdviceModel(userName: "mido mj", title: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار."),
//    AdviceModel(userName: "mido mj", title: "اشرب 8 أكواب ماء يوميًا للحفاظ على ترطيب جسمك"),
//    AdviceModel(userName: "mido mj", title: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.")
    
    func addAdvice() {
        let trimmedAdvice = newAdvice.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Trimmed Advice: \(trimmedAdvice)")
        guard !trimmedAdvice.isEmpty else {
            print("Advice is empty")
            return
        }
        // If editing, update the existing advice
        if let editingIndex = Advicies.firstIndex(where: { $0.id == editingAdvice?.id }) {
            Advicies[editingIndex].title = trimmedAdvice // Update the adive text
            editingAdvice = nil // Clear editing state
        } else {
            // Add a new advice
            let advice = AdviceModel(userName: "User\(Advicies.count + 1)",title: trimmedAdvice)
            Advicies.append(advice)
        }
        
        newAdvice = "" // Clear the input field
        print("Advicies after append: \(Advicies)")

    }
    
    func deleteAdvice(at indexSet: IndexSet) {
        Advicies.remove(atOffsets: indexSet)
    }
    
    func startEditing(advice: AdviceModel) {
        editingAdvice = advice
        newAdvice = advice.title // Populate the input field with the advice text
    }
   
}
