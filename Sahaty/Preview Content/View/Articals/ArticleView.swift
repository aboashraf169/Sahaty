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
    var userType: UserType // نوع المستخدم (Doctor أو Patient)
    @State private var showEditSheet = false // التحكم بعرض شاشة التعديل
    @State private var showDeleteAlert = false // التحكم بعرض التنبيه

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
                        Text("منذ \(articlesModel.addTime)")
                            .font(.subheadline)
                            .fontWeight(.light)
            
                    }
                    .opacity(0.6)
                }
                .padding(.horizontal, 5)
                Spacer()
                if userType == .doctor {
                    // زر الحذف
                    Button(role: .destructive) {
                        showDeleteAlert.toggle() // عرض التنبيه عند الحذف
                    } label: {
                            Label("", systemImage: "trash")
                    }
                .fontWeight(.ultraLight)
                .foregroundStyle(.primary)
                .alert("حذف المقالة", isPresented: $showDeleteAlert) {
                  
                        Button("موافقة", role: .destructive) {
                            articlesViewModel.deleteArticle(id: articlesModel.id)
                        }
                        Button("إلغاء", role: .cancel) {}

                    
                
                    
                   
                } message: {
                    Text("هل أنت متأكد من أنك تريد حذف المقالة؟")
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

            // صورة المنشور
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .foregroundStyle(Color(.systemGray6)).opacity(0.4)
                .cornerRadius(10)
                .overlay {
                    if let image = articlesModel.imagePost {
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
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

            // خيارات التفاعل
            FotterArtical(comments:articlesModel.comments)

        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .sheet(isPresented: $showEditSheet) {
            AddArticleSheetView(articalsViewModel: articlesViewModel)
        }
    }
}

#Preview {
    
    ArticleView(articlesModel: ArticalModel(description:  "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.", name: "محمد اشرف", userName: "midoMj@", addTime: "ساعتين"), articlesViewModel: ArticalsViewModel(), userType: .doctor)
}

