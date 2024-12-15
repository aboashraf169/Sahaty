import SwiftUI
import PhotosUI

struct AddArticleSheetView: View {
    @ObservedObject var articalsViewModel: ArticalsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("أنشئ مقالة جديدة!")
                .font(.title)
                .padding(.vertical)

            // Image Upload Button
            HStack {
                Button(action: {
                    articalsViewModel.showImagePicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "icloud.and.arrow.up")
                            .font(.title2)
                            .tint(.secondary)
                        Text("رفع الصورة")
                            .tint(.black)
                    }
                }
                .buttonStyle(.borderless)

                Spacer()

                Text("الموضوع")
                Image(systemName: "text.book.closed")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)

            // Text Editor
            TextEditor(text: $articalsViewModel.articleText)
                .frame(height: 150)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .multilineTextAlignment(.trailing)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.accentColor , lineWidth: 1)
                )
                .padding(.horizontal)

            // Image Preview
            RoundedRectangle(cornerRadius: 15)
                .frame(height: 160)
                .foregroundColor(Color(.secondarySystemBackground))
                .overlay {
                    if let image = articalsViewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } else {
                        VStack {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.secondary)
                            Text("لا يوجد صورة")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)

            // Publish Button
            Button(action: {
                guard !articalsViewModel.articleText.isEmpty else {
                    articalsViewModel.alertTitle = "خطأ"
                    articalsViewModel.alertMessage = "النص لا يمكن أن يكون فارغًا."
                    articalsViewModel.showAlert = true
                    return
                }
                articalsViewModel.addArtical(description: articalsViewModel.articleText, name: "محمد أشرف", userName: "@midoMj", addTime: "ساعتين", userType: .doctor)
                dismiss()
            }) {
                Text("نشر")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .photosPicker(isPresented: $articalsViewModel.showImagePicker, selection: $articalsViewModel.selectedImageItem)
        .onChange(of: articalsViewModel.selectedImageItem) { oldValue,newValue in
            articalsViewModel.loadImage(from: newValue)
        }
        .alert(isPresented: $articalsViewModel.showAlert) {
            Alert(title: Text(articalsViewModel.alertTitle), message: Text(articalsViewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AddArticleSheetView(articalsViewModel: ArticalsViewModel())
}
