import SwiftUI

struct FotterArtical: View {
    @State private var stateLike = false
    @State private var stateSave = false
    @State private var showCommentView = false
    @State private var showShereSheet = false
    @State var articleViewModel : ArticalsViewModel
    @State var id : Int
    @StateObject var commentsViewModel = CommentViewModel()
    @AppStorage("appLanguage") private var appLanguage = "ar"

    var commentCount: Int {
        commentsViewModel.comments.count
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                
                // زر الإعجاب
                Button {
                stateLike.toggle()
                articleViewModel.likeArtical(id: self.id)
                } label: {
                    HStack {
                        Image(systemName: stateLike ? "heart.fill" : "heart")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(stateLike ? .accent : .primary)
//                        Text("\(commentCount)")
//                            .font(.callout)
//                            .fontWeight(.ultraLight)
                    }
                }
                .foregroundStyle(.primary)

                
                // زر عرض التعليقات
                Button {
                    showCommentView.toggle()
                    commentsViewModel.fetchComments(idArtical: id)
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "message")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.primary)
//                        Text("\(commentCount)") // عرض عدد التعليقات
//                            .font(.callout)
//                            .fontWeight(.ultraLight)
                    }
                }
                .foregroundStyle(.primary)

                
                Spacer()
                // زر المشاركة
                Button {
                    showShereSheet.toggle()
                    
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                }
                .foregroundStyle(.primary)
                // زر الحفظ
                Button {
                    stateSave.toggle()
                    articleViewModel.savedArtical(id: self.id)
                } label: {
                    Image(systemName: stateSave ? "bookmark.fill" : "bookmark")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(stateSave ? .accent : .primary)
                }
     
                
            }
            
            .padding(.horizontal)
            .actionSheet(isPresented: $showShereSheet) {
                getActionSheet()
            }
            .sheet(isPresented: $showCommentView) {
                AddCommentView(viewModel: commentsViewModel,id: id)
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.7)])
            }

            Divider()
            .padding(.top, 5)
        }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
    }

    private func getActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("share_action_sheet_title".localized()),
            buttons: [
                .default(Text("share".localized())) {},
                .cancel(Text("cancel".localized()))
            ]
        )
    }
}

#Preview {
    FotterArtical(articleViewModel: ArticalsViewModel(), id: 0)
}
