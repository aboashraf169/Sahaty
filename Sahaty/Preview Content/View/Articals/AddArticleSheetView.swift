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
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        VStack {
            // MARK: - Header Section
            VStack(spacing: 10) {
                Text(articalsViewModel.editingArticle == nil ? "create_new_article".localized() : "edit_article".localized())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Text("fill_fields_for_article".localized())
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical)

            // MARK: - Article Text Section
            VStack(alignment: .trailing, spacing: 10) {
                HStack {
                    Image(systemName: "text.book.closed")
                    Text("topic".localized())
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
                    Text("upload_image".localized())
                        .tint(.black)
                    Spacer()
                  
                }

                HStack {
                    Button(action: {
                        articalsViewModel.showImagePicker.toggle()
                    }) {
                        HStack {
                            Text("choose_image".localized())
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
                                Text("no_image_selected".localized())
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
                    articalsViewModel.alertTitle = "error".localized()
                    articalsViewModel.alertMessage = "text_empty_error".localized()
                    articalsViewModel.showAlert = true
                    return
                }
                articalsViewModel.saveArticle()
                dismiss()
            }) {
                Text(articalsViewModel.editingArticle == nil ? "publish".localized() : "save_changes".localized())
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
                dismissButton: .default(Text("ok".localized()))
            )
        }
        .padding(.top)
        .direction(appLanguage) // لضبط اتجاه النصوص بناءً على اللغة
        .environment(\.locale, .init(identifier: appLanguage)) // تطبيق اللغة المختارة
    }
}

#Preview {
    AddArticleSheetView(articalsViewModel: ArticalsViewModel(currentUser: .doctor(DoctorModel(
        fullName: "د. محمد علي",
        email: "test@example.com",
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
