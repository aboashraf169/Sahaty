import Foundation

class CommentViewModel: ObservableObject {
    @Published var comments: [CommentModel] = [] // قائمة التعليقات
    @Published var newCommentText: String = "" // نص التعليق الجديد
    @Published var editingComment: CommentModel? // التعليق الذي يتم تعديله
    @Published var errorMessage: String? = nil // رسالة خطأ
    @Published var successMessage: String? = nil // رسالة نجاح

    // إضافة تعليق جديد
    func addComment(author: CommentAuthor) {
        let trimmedText = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            errorMessage = "empty_comment".localized()
            return
        }
        
        if let editingIndex = comments.firstIndex(where: { $0.id == editingComment?.id }) {
            // تعديل تعليق موجود
            comments[editingIndex].text = trimmedText
            editingComment = nil
            successMessage = "comment_edited".localized()
        } else {
            // إضافة تعليق جديد
            let newComment = CommentModel(
                text: trimmedText,
                author: author,
                publishDate: Date()
            )
            comments.append(newComment)
            successMessage = "comment_added".localized()
        }
        
        newCommentText = "" // مسح الحقل بعد الإضافة
    }

    // حذف تعليق
    func deleteComment(id: UUID) {
        if let index = comments.firstIndex(where: { $0.id == id }) {
            comments.remove(at: index)
            successMessage = "comment_deleted".localized()
        } else {
            errorMessage = "comment_not_found".localized()
        }
    }

    // بدء تعديل تعليق
    func startEditing(comment: CommentModel) {
        editingComment = comment
        newCommentText = comment.text
    }
}
