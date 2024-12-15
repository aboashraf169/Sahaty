//
//  ArticleView.swift
//  Sahaty
//
//  Created by mido mj on 12/15/24.


import SwiftUI


struct ShowArtical: View {

    let artical: ArticalModel

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // Post settings
                    Menu("", systemImage: "ellipsis") {
                        Button {
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("حذف المنشور")
                            }
                        }
                        Button {
                            // Edit action
                        } label: {
                            HStack {
                                Image(systemName: "pencil")
                                Text("تعديل المنشور")
                            }
                        }
                    }
                    .foregroundStyle(.black)
                

                Spacer()

                // Post owner details
                VStack(alignment: .trailing) {
                    Text("د.\(artical.name)")
                        .font(.headline)
                        .fontWeight(.regular)

                    HStack {
                        Text("منذ\(artical.addTime)")
                            .font(.subheadline)
                            .fontWeight(.light)

                        Text(artical.userName)
                            .font(.subheadline)
                            .fontWeight(.light)
                    }
                    .opacity(0.6)
                }
                .padding(.horizontal, 5)

                // Owner image
                if let image = artical.personImage {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 7)
                        .frame(width: 50, height: 50)
                        .background(Color.accentColor)
                        .cornerRadius(25)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .frame(width: 40, height: 40)
                        .background(Color.accentColor)
                        .cornerRadius(20)
                }
            }

            // Post description
            Text(artical.description)
                .font(.callout)
                .fontWeight(.light)
                .multilineTextAlignment(.trailing)

            // Post image
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .foregroundStyle(Color(.systemGray6)).opacity(0.4)
                .cornerRadius(10)
                .overlay {
                    if let image = artical.imagePost {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(25)
                    } else {
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .foregroundStyle(.accent)
                                .frame(width: 100, height: 100)
                            Text("No Image")
                                .foregroundStyle(.accent)
                        }
                    }
                }

            // Post footer
            FotterArtical()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 350)
        .padding(.vertical, 10)
        .padding(.horizontal)
        

    }
}

#Preview {
    let artical = ArticalModel(
        description: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.",
        name: "محمد اشرف",
        userName: "midoMj@",
        addTime: "ساعتين",
        imagePost: "post",
        personImage: "doctor")
    ShowArtical(artical: artical)
}


struct FotterArtical: View {
    
    @ObservedObject  var viewModel = ArticalsViewModel()

    var body: some View {
        VStack {
            HStack(spacing: 30) {
                Button {
                    viewModel.toggleSave()
                } label: {
                    Image(systemName: viewModel.stateSave ? "bookmark.fill" : "bookmark")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(viewModel.stateSave ? .accent : .black)
                }

                Spacer()

                Button {
                    viewModel.toggleShareSheet()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(.black)
                }
                Button {
                    viewModel.toggleCommentView()
                } label: {
                    Image(systemName: "message")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(.black)
                }
                Button {
                    viewModel.toggleLike()
                } label: {
                    Image(systemName: viewModel.stateLike ? "heart.fill" : "heart")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(viewModel.stateLike ? .accent : .black)
                }
            }
            .actionSheet(isPresented: $viewModel.showShareSheet){
                getActionSheet()
            }
            .sheet(isPresented: $viewModel.showCommentView) {
                CommentScreen()
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.7)])
            }

            Divider()
                .padding(.top, 5)
        }
    }
    func getActionSheet() -> ActionSheet {
        
        let title = Text("ماذا تريد ان تفعل")
        let ShereButton : ActionSheet.Button =  .default(Text("مشاركة")){
            
        }
        
        let CancelButton : ActionSheet.Button = .cancel(Text("الغاء"))
        
    
            return  ActionSheet(
                title: title,
                message: Text("") ,
                buttons: [ShereButton,CancelButton]
            )
        
        }

}
