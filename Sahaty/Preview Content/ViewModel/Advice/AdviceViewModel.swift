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
    
    init() {
        fetchAdvices() // جلب النصائح من الخادم وحفظها في Core Data
        loadAdvicesFromCoreData() // تحميل النصائح من Core Data عند عدم وجود اتصال
        
    }

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
                self?.fetchAdvices() // إعادة جلب النصائح من الخادم
                completion(true)
            }
        }.resume()
    }

    // MARK: - Get Advices
    
    func fetchAdvices() {
        isLoading = true

        // استخدام APIManager لإرسال الطلب
        APIManager.shared.sendRequest(
            endpoint: "/doctor/get-today-advice", // مسار الـ API
            method: .get // نوع الطلب GET
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    // طباعة البيانات الخام للتحقق
                    do {
                        // فك ترميز البيانات
                        let response = try JSONDecoder().decode(AdviceResponse.self, from: data)
                        // تحديث النصائح في ViewModel
                        self?.advices = response.data
                        // حفظ النصائح في Core Data
                        CoreDataManager.shared.saveAdvicesToCoreData(response.data)
                        self?.advices = CoreDataManager.shared.fetchAdvices() // إعادة تحميل البيانات من Core Data

                        
                    } catch {
                        // التعامل مع أخطاء فك الترميز
                        print("Decoding error: \(error.localizedDescription)")
                        self?.errorMessage = "Failed to parse advice data."
                        self?.advices = CoreDataManager.shared.fetchAdvices()
                    }
                case .failure(let error):
                    // التعامل مع أخطاء الشبكة أو الخادم
                    print("Error fetching advices: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    self?.advices = CoreDataManager.shared.fetchAdvices()
                }
            }
        }
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
