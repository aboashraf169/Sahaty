
import Foundation

class CommentViewModel: ObservableObject {
    @Published var comments: [CommentModel] = [
        CommentModel(username: "Ali123", image: nil, text: "مقال رائع جدًا!"),
        CommentModel(username: "Sara.A", image: nil, text: "شكراً على المعلومات القيمة 🌟"),
        CommentModel(username: "Dr.Mohammed", image: nil, text: "مزيد من التوضيحات ستكون مفيدة."),
        CommentModel(username: "NoImageUser", image: nil, text: "تعليق بدون صورة شخصية.")
    ]
    
    @Published var newComment: String = ""
    @Published var editingComment: CommentModel? // Track the comment being edited

    func addComment() {
        let trimmedComment = newComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedComment.isEmpty else { return }
        
        // If editing, update the existing comment
        if let editingIndex = comments.firstIndex(where: { $0.id == editingComment?.id }) {
            comments[editingIndex].text = trimmedComment // Update the comment text
            editingComment = nil // Clear editing state
        } else {
            // Add a new comment
            let comment = CommentModel(username: "User\(comments.count + 1)", image: nil, text: trimmedComment)
            comments.append(comment)
        }
        
        newComment = "" // Clear the input field
    }
    
    func deleteComment(at indexSet: IndexSet) {
        comments.remove(atOffsets: indexSet)
    }
    
    func startEditing(comment: CommentModel) {
        editingComment = comment
        newComment = comment.text // Populate the input field with the comment text
    }
}
