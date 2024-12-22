//
//  AddArticleSheetView 2.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//


import SwiftUI
import PhotosUI


struct AddArticleSheetView: View {
    @ObservedObject var articalsViewModel: ArticalsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            // MARK: - Header Section
            VStack(spacing: 10) {
                Text(articalsViewModel.editingArticle == nil ? "إنشاء مقالة جديدة" : "تعديل المقالة")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("املأ الحقول أدناه لإضافة أو تعديل المقالة")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical)

            // MARK: - Article Text Section
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    Image(systemName: "text.book.closed")
                    Text("الموضوع")
                    Spacer()
                }

                TextEditor(text: $articalsViewModel.articleText)
                    .frame(height: 120)
                    .padding(10)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            .padding(.vertical,10)
            
            // MARK: - Upload Image Section
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    Image(systemName: "icloud.and.arrow.up")
                        .font(.title2)
                        .tint(.secondary)
                    Text("رفع الصورة")
                        .tint(.black)
                    Spacer()
                  
                }

                HStack {
                    Button(action: {
                        articalsViewModel.showImagePicker.toggle()
                    }) {
                        HStack {
                            Text("اختر صورة")
                                .font(.headline)
                            Image(systemName: "icloud.and.arrow.up")
                                .font(.title3)
                           
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    }
                }

                // عرض الصورة المحددة
                if let image = articalsViewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 200)
                        .shadow(radius: 5)

                    Spacer()
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.secondary)
                        .frame(height: 150)
                        .overlay {
                            VStack {
                                Image(systemName: "photo.on.rectangle")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                Text("لا يوجد صورة محددة")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical,10)



            Spacer()

            // MARK: - Publish Button
            Button(action: {
                guard !articalsViewModel.articleText.isEmpty else {
                    articalsViewModel.alertTitle = "خطأ"
                    articalsViewModel.alertMessage = "النص لا يمكن أن يكون فارغًا."
                    articalsViewModel.showAlert = true
                    return
                }
                articalsViewModel.saveArticle()
                dismiss()
            }) {
                Text(articalsViewModel.editingArticle == nil ? "نشر" : "حفظ التعديلات")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .shadow(radius: 3)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .photosPicker(isPresented: $articalsViewModel.showImagePicker, selection: $articalsViewModel.selectedImageItem)
        .onChange(of: articalsViewModel.selectedImageItem) { _, newValue in
            articalsViewModel.loadImage(from: newValue)
        }
        .alert(isPresented: $articalsViewModel.showAlert) {
            Alert(
                title: Text(articalsViewModel.alertTitle),
                message: Text(articalsViewModel.alertMessage),
                dismissButton: .default(Text("حسنًا"))
            )
        }
        .padding(.top)
    }
}

#Preview {
    AddArticleSheetView(articalsViewModel: ArticalsViewModel(currentUser: .doctor(DoctorModel(
        fullName: "د. محمد علي",
        email: "test@example.com",
        password: "123456",
        specialization: "أمراض القلب",
        licenseNumber: "12345",
        articlesCount: 10,
        advicesCount: 5,
        followersCount: 50,
        articles: [],
        advices: [],
        comments: [],
        likedArticles: []
    ))))
}
