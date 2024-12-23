
import Foundation

import Foundation

class CommentViewModel: ObservableObject {
    @Published var comments: [CommentModel] = [] // قائمة التعليقات
    @Published var newCommentText: String = "" // نص التعليق الجديد
    @Published var editingComment: CommentModel? // التعليق الذي يتم تعديله

    // إضافة تعليق جديد
    func addComment(author: CommentAuthor) {
        let trimmedText = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        if let editingIndex = comments.firstIndex(where: { $0.id == editingComment?.id }) {
            // تعديل تعليق موجود
            comments[editingIndex].text = trimmedText
            editingComment = nil
        } else {
            // إضافة تعليق جديد
            let newComment = CommentModel(
                text: trimmedText,
                author: author,
                publishDate: Date()
            )
            comments.append(newComment)
        }
        
        newCommentText = "" // مسح الحقل بعد الإضافة
    }

    // حذف تعليق
    func deleteComment(id: UUID) {
        comments.removeAll { $0.id == id }
    }
    

    // بدء تعديل تعليق
    func startEditing(comment: CommentModel) {
        editingComment = comment
        newCommentText = comment.text
    }
}

