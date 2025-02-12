//
//  SwiftUIView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI


struct ArticleView: View {
    var articleModel: ArticleModel
    @ObservedObject var articalViewModel : ArticalsViewModel
    var usersType: UsersType
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @AppStorage("appLanguage") private var appLanguage = "ar"
    var path : String

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // صورة صاحب المنشور
                
                if let image = articalViewModel.doctorImage{
                    Image(uiImage:image)
                        .resizable()
                        .scaledToFill()
                        .shadow(radius: 2)
                        .padding(.top, 5)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(.top,3)
                        .frame(width: 40, height: 40)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                
                // بيانات صاحب المنشور
                VStack(alignment: .leading) {
                    Text(articleModel.doctor.name)
                        .font(.headline)
                        .fontWeight(.regular)
                    Text(articleModel.doctor.email)
                        .font(.subheadline)
                        .fontWeight(.light)
                    .opacity(0.6)
                }
                .padding(.horizontal, 5)
                Spacer()
                if usersType == .doctor {
                    // زر الحذف
                    Button(role: .destructive) {
                        showDeleteAlert.toggle() // عرض التنبيه عند الحذف
                    } label: {
                            Label("", systemImage: "trash")
                    }
                .fontWeight(.ultraLight)
                .foregroundStyle(.primary)
                .alert("delete_article".localized(), isPresented: $showDeleteAlert) {
                    Button("confirm".localized(), role: .destructive) {
                        articalViewModel.deleteAdvice(id: articleModel.id)
                    }
                    Button("cancel".localized(), role: .cancel) {}
                }message:{
                    Text("delete_article_confirmation".localized())
                       }
                   
                    // زر التعديل
                        Button {
                            showEditSheet.toggle() // عرض شاشة التعديل
                        } label: {
                            Label("", systemImage: "pencil.line")
                        }
                        .fontWeight(.ultraLight)
                        .foregroundStyle(.primary)
                        .padding(.leading)
                }
            }

            // وصف المنشور
            HStack {
                Text(articleModel.title)
                    .font(.title3)
                    .fontWeight(.light)
                Spacer()
            }
            
            Text(articleModel.subject)
                .font(.callout)
                .fontWeight(.light)
        
            if let image = articalViewModel.loadedImage {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .foregroundStyle(Color(.systemGray6)).opacity(0.4)
                    .cornerRadius(10)
                    .overlay {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    }
            }
        
            FotterArtical(articleViewModel: articalViewModel, id: articleModel.id)

        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
        .sheet(isPresented: $showEditSheet) {
            EditArticleSheetView(articalsViewModel: articalViewModel, article: articleModel)
        }
        .onAppear{
            articalViewModel.loadImage(from: path)
            articalViewModel.doctorImage(from: path)
        }
    }
}

#Preview {
    ArticleView(articleModel: ArticleModel(id: 0, title: "كيفية الوقاية من أمراض القلب", subject: "تتعدد طرق الوقاية من أمراض القلب مثل تقليل التوتر، تناول غذاء صحي غني بالألياف، ممارسة الرياضة بانتظام، والحفاظ على وزن صحي. يجب على الأشخاص الذين لديهم تاريخ عائلي لأمراض القلب أن يتابعوا فحوصاتهم الطبية بشكل دوري.", img: nil, doctor: ArticleDoctor(id: 1, name: "احمد ماهر معين الحناوي", email: "mido@gmail.com", img: "post2")), articalViewModel: ArticalsViewModel(), usersType: .doctor, path: "")
}

