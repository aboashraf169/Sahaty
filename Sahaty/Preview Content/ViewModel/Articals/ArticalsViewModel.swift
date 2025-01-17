import Foundation
import PhotosUI
import SwiftUI
import Combine

class ArticalsViewModel: ObservableObject {
    // MARK: - Properties
    @Published var Articals: [ArticleModel] = [] // قائمة المقالات
    @Published var articleText: String = "" // النص الجديد للمقالة
    @Published var selectedImage: UIImage? = nil // الصورة المختارة
    @Published var selectedImageItem: PhotosPickerItem? = nil
    @Published var editingArticle: ArticleModel? // المقالة التي يتم تعديلها
    @Published var showImagePicker: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    // MARK: - Add or Edit Article
    func saveArticle() {
        clearAlert()

        let trimmedText = articleText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            showAlert(title: "error_title".localized(), message: "empty_article_error".localized())
            return
        }

        if let editingIndex = Articals.firstIndex(where: { $0.id == editingArticle?.id }) {
            // تعديل المقالة
            Articals[editingIndex].subject = trimmedText
            editingArticle = nil
        } else {
            // إضافة مقالة جديدة
//            let newArticle =
//            ArticleModel(id: 0, title: "عنوان", description: trimmedText, author: "محمد اشرف", publishDate: "ساعة", imagePost: selectedImage != nil ? "newImage" : nil, likeCount: 0, commentCount: 0)
//            Articals.append(newArticle)
        }

        resetFields()
    }
    
    func fetchArticles() {
        // جلب المقالات من Core Data
        let localArticles = CoreDataManager.shared.fetchArticles()
        if !localArticles.isEmpty {
            self.Articals = localArticles
        }
        
        // التحقق من الاتصال بالإنترنت
        APIManager.shared.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self?.Articals = articles
                    print("Received Articles: \(articles)")
                    CoreDataManager.shared.saveArticles(articles)
                case .failure(let error):
                    print("Failed to fetch articles from API: \(error.localizedDescription)")
                }
            }
        }


    }


    // MARK: - Start Editing Article
    func startEditing(article: ArticleModel) {
        editingArticle = article
        articleText = article.subject // تعبئة النص الحالي في الحقل
    }

    // MARK: - Delete Article
    func deleteArticle(id: UUID) {
//        if let index = Articals.firstIndex(where: { $0.id == id }) {
//            Articals.remove(at: index)
//        } else {
//            showAlert(title: "error_title".localized(), message: "article_not_found_error".localized())
//        }
    }

    // MARK: - Reset Fields
    func resetFields() {
        articleText = ""
        selectedImage = nil
        editingArticle = nil
    }

    // MARK: - Load Image
    func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: ImageTransferable.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transferableImage):
                    self.selectedImage = transferableImage?.image
                case .failure(let error):
                    self.showAlert(title: "error_title".localized(), message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }

    private func clearAlert() {
        alertTitle = ""
        alertMessage = ""
    }
}

/// A wrapper for UIImage that conforms to Transferable.
struct ImageTransferable: Transferable {
    let image: UIImage
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw ImageTransferableError.importFailed
            }
            return ImageTransferable(image: uiImage)
        }
    }
}

// Custom Error for Transferable
enum ImageTransferableError: Error {
    case importFailed
}












