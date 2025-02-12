import SwiftUI

struct AddCommentView: View {
    @ObservedObject  var viewModel : CommentViewModel
    @State var id : Int
    @AppStorage("appLanguage") private var appLanguage = "ar"
    @State var showAlert = false
    let currentUserID = UserDefaults.standard.integer(forKey: "currentUserID")

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.comments) { comment in
                        CommentView(comment: comment)
                            .swipeActions(edge: .leading) {
                                if comment.user.id == currentUserID{
                                    Button("delete", role: .destructive) {
                                        viewModel.deleteComment(idComment: comment.id)
                                    }
                                }
                            }

//                            .swipeActions(edge: .leading){
//                                    Button("delete", role: .destructive) {
//                                        viewModel.deleteComment(idComment: comment.id)
//                                    }
//                                }
                    }
                }
                
                HStack {
                    TextField("add_comment_placeholder".localized(), text: $viewModel.comment.comment)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .padding(.horizontal)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    Spacer()
                    Button(action: {
                        viewModel.addComment(idArtical: id, comment: viewModel.comment.comment)
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
//            .alert("حذف التعليق", isPresented: $showAlert) {
//                Button("delete".localized(), role: .destructive) {
//                    viewModel.deleteComment(idComment: viewModel.comment.id)
//                }
//                Button("cancel", role: .cancel){}
//            }message: {
//              Text("هل انت متاكد انك تريد الحذف")
//            }
        }
    }
}



#Preview {
    AddCommentView(viewModel: CommentViewModel(), id: 0)
}
