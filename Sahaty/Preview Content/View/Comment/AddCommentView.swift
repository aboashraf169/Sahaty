import SwiftUI

struct AddCommentView: View {
    @StateObject private var viewModel = CommentViewModel()
    var currentUser: CommentAuthor // المستخدم الحالي (طبيب أو مريض)

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
                    TextField("أضف تعليقًا...", text: $viewModel.newCommentText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    Spacer()
                    Button(action: {
                        viewModel.addComment(author: currentUser)
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
            .navigationTitle("التعليقات")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func swipeActions(for comment: CommentModel) -> some View {
        Group {
            // تعديل
            Button {
                viewModel.startEditing(comment: comment)
            } label: {
                Label("تعديل", systemImage: "pencil")
            }
            .tint(.accent)

            // حذف
            Button() {
                viewModel.deleteComment(id: comment.id)
            } label: {
                Label("حذف", systemImage: "trash")
            }
            .tint(.red)
        }
    }
}



#Preview {
    let currentUser = DoctorModel(
        id: UUID(),
        fullName: "الحارٍٍث نبيل",
        email: "mohamed@example.com",
        specialization: "Cardiology", // التخصص
        licenseNumber: "123456789", // رقم الترخيص
        profilePicture: nil, // صورة اختيارية
        biography: "استشاري أمراض القلب", // السيرة الذاتية
        articlesCount: 10, // عدد المقالات
        advicesCount: 15, // عدد النصائح
        followersCount: 200, // عدد المتابعين
        articles: [], // قائمة المقالات
        advices: [], // قائمة النصائح
        comments: [], // قائمة التعليقات
        likedArticles: [] // قائمة المقالات المعجب بها
    )
    AddCommentView(currentUser: .doctor(currentUser))
}
