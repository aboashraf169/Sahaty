//
//  SwiftUIView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI


struct ArticleView: View {
    var articlesModel: ArticalModel
    @StateObject var articlesViewModel: ArticalsViewModel
    var usersType: UsersType // نوع المستخدم (Doctor أو Patient)
    @State private var showEditSheet = false // التحكم بعرض شاشة التعديل
    @State private var showDeleteAlert = false // التحكم بعرض التنبيه
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                // إعدادات المنشور للأطباء فقط
                
                // صورة صاحب المنشور
                if let image = articlesModel.personImage {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
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
                    Text(articlesModel.name)
                        .font(.headline)
                        .fontWeight(.regular)
                    
                    HStack {
                        Text(articlesModel.userName)
                            .font(.subheadline)
                            .fontWeight(.light)
                        Text("\("since".localized()) \(articlesModel.addTime)")
                            .font(.subheadline)
                            .fontWeight(.light)
            
                    }
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
                                   articlesViewModel.deleteArticle(id: articlesModel.id)
                               }
                               Button("cancel".localized(), role: .cancel) {}
                           
                       } message: {
                           Text("delete_article_confirmation".localized())
                       }
                   
                    // زر التعديل
                        Button {
                            articlesViewModel.startEditing(article: articlesModel)
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
            Text(articlesModel.description)
                .font(.callout)
                .fontWeight(.light)

            
            if let image = articlesModel.imagePost {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .foregroundStyle(Color(.systemGray6)).opacity(0.4)
                    .cornerRadius(10)
                    .overlay {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    }
            }
        
            // خيارات التفاعل
            FotterArtical(comments:articlesModel.comments)

        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .sheet(isPresented: $showEditSheet) {
            AddArticleSheetView(articalsViewModel: articlesViewModel)
        }
        .direction(appLanguage) // لضبط اتجاه النصوص بناءً على اللغة
               .environment(\.locale, .init(identifier: appLanguage)) // تطبيق اللغة المختارة
    }
}

#Preview {
    
    ArticleView(articlesModel: ArticalModel(description:  "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.", name: "محمد اشرف", userName: "midoMj@", addTime: "ساعتين",imagePost: "post"), articlesViewModel: ArticalsViewModel(), usersType: .doctor)
}

