import Foundation
import SwiftUI
import Combine

import Foundation
import Combine

class AdviceViewModel: ObservableObject {
    // MARK: - Properties
    @Published var advices: [AdviceModel] = [] // النصائح
    @Published var isLoading: Bool = false // حالة التحميل
    @Published var errorMessage: String? = nil // رسالة الخطأ
    @Published var newAdviceText: String = "" // النص الجديد/المعدل
    @Published var editingAdvice: AdviceModel? = nil // النصيحة التي يتم تعديلها

    private var cancellables = Set<AnyCancellable>()

    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - Add or Update Advice
    func addOrUpdateAdvice() {
        let trimmedAdvice = newAdviceText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAdvice.isEmpty else {
            errorMessage = "Advice content cannot be empty."
            return
        }

        if let editingAdvice = editingAdvice {
            // تعديل نصيحة
            updateAdvice(id: editingAdvice.id, newContent: trimmedAdvice) { [weak self] success in
                if success {
                    self?.clearEditing()
                } else {
                    self?.errorMessage = "Failed to update advice."
                }
            }
        } else {
            // إضافة نصيحة جديدة
            addAdvice(trimmedAdvice) { [weak self] success in
                if success {
                    self?.clearEditing()
                }
            }
        }
    }
    
    // MARK: - Add Advice
    func addAdvice(_ adviceContent: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/doctor/advice/store") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["advice": adviceContent]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error adding advice: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data received.")
                completion(false)
                return
            }

            do {
                let advice = try JSONDecoder().decode(AdviceModel.self, from: data)
                DispatchQueue.main.async {
                    self?.advices.append(advice)
                    CoreDataManager.shared.saveAdvicesToCoreData(self?.advices ?? [])
                    completion(true)
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }

    // MARK: - Update Advice
    func updateAdvice(id: Int, newContent: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/doctor/advice/\(id)/update") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["advice": newContent]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error updating advice: \(error.localizedDescription)")
                completion(false)
                return
            }

            DispatchQueue.main.async {
                if let index = self?.advices.firstIndex(where: { $0.id == id }) {
                    self?.advices[index].advice = newContent
                    CoreDataManager.shared.saveAdvicesToCoreData(self?.advices ?? [])
                }
                completion(true)
            }
        }.resume()
    }

    // MARK: - Get Advices
    func fetchAdvices() {
        isLoading = true
        guard let url = URL(string: "http://127.0.0.1:8000/api/doctor/get-today-advice") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false

                if let error = error {
                    print("Error fetching advices: \(error.localizedDescription)")
                    self?.advices = CoreDataManager.shared.fetchAdvices()
                    return
                }

                guard let data = data else {
                    print("No data received.")
                    self?.advices = CoreDataManager.shared.fetchAdvices()
                    return
                }

                do {
                    let response = try JSONDecoder().decode(AdviceResponse.self, from: data)
                    self?.advices = response.data
                    CoreDataManager.shared.saveAdvicesToCoreData(response.data)
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    self?.advices = CoreDataManager.shared.fetchAdvices()
                }
            }
        }.resume()
    }

    // MARK: - Delete Advice
    func deleteAdvice(id: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/doctor/advice/\(id)/destroy") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error deleting advice: \(error.localizedDescription)")
                completion(false)
                return
            }

            DispatchQueue.main.async {
                self?.advices.removeAll { $0.id == id }
                CoreDataManager.shared.saveAdvicesToCoreData(self?.advices ?? [])
                completion(true)
            }
        }.resume()
    }
    
   // MARK: - Clear Local Data
    func clearLocalData() {
        advices.removeAll()
        CoreDataManager.shared.deleteAllAdvices()
    }
    
    // MARK: - Clear Editing
    func clearEditing() {
        editingAdvice = nil
        newAdviceText = ""
    }

    // MARK: - Start Editing
    func startEditing(advice: AdviceModel) {
        editingAdvice = advice
        newAdviceText = advice.advice
    }
}


// Response Model
struct AdviceResponse: Decodable {
    let data: [AdviceModel]
}

extension AdviceViewModel {
    func loadAdvicesFromCoreData() {
        advices = CoreDataManager.shared.fetchAdvices()
    }
}
