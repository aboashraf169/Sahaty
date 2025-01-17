import SwiftUI

struct AddCommentView: View {
    @StateObject private var viewModel = CommentViewModel()
//    var currentUser: CommentAuthor // المستخدم الحالي (طبيب أو مريض)
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        NavigationStack {
            VStack {
                // قائمة التعليقات
                List {
                    ForEach(viewModel.comments) { comment in
                        CommentView(comment: comment)
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                swipeActions(for: comment)
                            }
                    }
                }
                
                // إضافة أو تعديل تعليق
                HStack {
                    TextField("add_comment_placeholder".localized(), text: $viewModel.newCommentText) // أضف تعليقًا...
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    Spacer()
                    Button(action: {
                        viewModel.addComment(author: "mido")
                    }) {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.accentColor)
                            .background(
                                Rectangle()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(Color(.systemGray6))
                                    .cornerRadius(10)
                            )
                            .padding(.horizontal)
                    }


               
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
            }
            .navigationTitle("comments".localized()) // التعليقات
            .navigationBarTitleDisplayMode(.inline)
            .direction(appLanguage) // اتجاه النصوص
            .environment(\.locale, .init(identifier: appLanguage))
        }
    }

    private func swipeActions(for comment: CommentModel) -> some View {
        Group {
            // تعديل
            Button {
                viewModel.startEditing(comment: comment)
            } label: {
                Label("edit".localized(), systemImage: "pencil") // تعديل
            }
            .tint(.accent)

            // حذف
            Button() {
//                viewModel.deleteComment(id: comment.id)
            } label: {
                Label("delete".localized(), systemImage: "trash") // حذف
            }
            .tint(.red)
        }
    }
}



#Preview {

//    AddCommentView(currentUser: .doctor(currentUser))
}
