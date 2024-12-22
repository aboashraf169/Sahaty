import Foundation
import SwiftUI
import PhotosUI
import Foundation
import SwiftUI
import PhotosUI

class ArticalsViewModel: ObservableObject {
    // MARK: - Properties
    @Published var Articals: [ArticalModel] = [] // قائمة المقالات
    @Published var articleText: String = "" // النص الجديد للمقالة
    @Published var selectedImage: UIImage? = nil // الصورة المختارة
    @Published var selectedImageItem: PhotosPickerItem? = nil
    @Published var editingArticle: ArticalModel? // المقالة التي يتم تعديلها
    @Published var showImagePicker: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""

    var currentUser: CommentAuthor? // المستخدم الحالي (Doctor أو Patient)

    // MARK: - Initialization
    init(currentUser: CommentAuthor? = nil) {
        self.currentUser = currentUser
        addDefaultData()
    }

    // MARK: - Add Default Articles
    private func addDefaultData() {
        Articals = [
            ArticalModel(
                description: "اشرب 8 أكواب ماء يوميًا للحفاظ على ترطيب جسمك.",
                name: "د. محمد أشرف",
                userName: "@midoMj",
                addTime: "ساعتين",
                imagePost: "post",
                personImage: "doctor"
            ),
            ArticalModel(
                description: "قم بممارسة الرياضة بانتظام لتحسين صحتك.",
                name: "د. أحمد علي",
                userName: "@ahmedAli",
                addTime: "ساعة",
                imagePost: nil,
                personImage: "doctor"
            )
        ]
    }


    // MARK: - Add or Edit Article
    func saveArticle() {
        clearAlert()

        let trimmedText = articleText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            showAlert(title: "خطأ", message: "المقالة لا يمكن أن تكون فارغة.")
            return
        }


        if let editingIndex = Articals.firstIndex(where: { $0.id == editingArticle?.id }) {
            // تعديل المقالة
            Articals[editingIndex].description = trimmedText
            editingArticle = nil
        } else {
            // إضافة مقالة جديدة
            let newArticle = ArticalModel(
                description: trimmedText,
                name: getCurrentUserName(),
                userName: "@\(getCurrentUserName().replacingOccurrences(of: " ", with: ""))",
                addTime: "الآن",
                imagePost: selectedImage != nil ? "newImage" : nil, // رابط الصورة إذا وجدت
                personImage: "doctor" // صورة المستخدم (افتراضية هنا)
            )
            Articals.append(newArticle)
        }

        resetFields()
    }
    

    // MARK: - Start Editing Article
    func startEditing(article: ArticalModel) {
        editingArticle = article
        articleText = article.description // تعبئة النص الحالي في الحقل
    }
    
    
    // MARK: - Delete Article
    func deleteArticle(id: UUID) {
        if let index = Articals.firstIndex(where: { $0.id == id }) {
            Articals.remove(at: index)
        } else {
            showAlert(title: "خطأ", message: "تعذر العثور على المقالة.")
        }
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
                    self.showAlert(title: "خطأ", message: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Utility Methods
    private func getCurrentUserName() -> String {
        switch currentUser {
        case .doctor(let doctor):
            return doctor.fullName
        case .patient(let patient):
            return patient.fullName
        default:
            return "مستخدم مجهول"
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
