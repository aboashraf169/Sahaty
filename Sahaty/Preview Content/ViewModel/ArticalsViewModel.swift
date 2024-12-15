//
//  PostViewModel.swift
//  Sahaty
//
//  Created by mido mj on 12/15/24.
//


import Foundation
import SwiftUI
import PhotosUI


class ArticalsViewModel: ObservableObject {
    
    @Published var Articals: [ArticalModel] = [
  
]
//    ArticalModel(description: "اشرب 8 أكواب ماء يوميًا للحفاظ على ترطيب جسمك", name: "محمد أشرف", userName: "@midoMj", addTime: "ساعتين", userType: .doctor),
//    ArticalModel(description: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.", name: "محمد أشرف", userName: "@midoMj", addTime: "ساعة", userType: .patient),
//    
//    ArticalModel(description: "اشرب 8 أكواب ماء يوميًا للحفاظ على ترطيب جسمك", name: "محمد أشرف", userName: "@midoMj", addTime: "ساعتين", userType: .doctor),
//    ArticalModel(description: "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.", name: "محمد أشرف", userName: "@midoMj", addTime: "ساعة", userType: .patient),



    @Published var stateLike: Bool = false
    @Published var stateSave: Bool = false
    @Published var showCommentView: Bool = false
    @Published var showShareSheet: Bool = false
    @Published var articleText: String = ""
    @Published var selectedImage: UIImage? = nil
    @Published var showImagePicker: Bool = false
    @Published var selectedImageItem: PhotosPickerItem? = nil
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    var isArticleTextValid: Bool {
        !articleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    

    // Resets all input fields.
    func resetFields() {
        articleText = ""
        selectedImage = nil
    }
    
    // Loads the selected image from the PhotosPicker.
    func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        item.loadTransferable(type: ImageTransferable.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transferableImage):
                    self.selectedImage = transferableImage?.image
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    
    // Displays an alert with the specified title and message.
    private func showAlert(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showAlert = true
    }
    
    
    // Add a new post
     func addArtical(description: String, name: String, userName: String, addTime: String, imagePost: String? = nil, personImage: String? = nil, userType: UserType) {
         let newPost = ArticalModel(
             description: description,
             name: name,
             userName: userName,
             addTime: addTime,
             imagePost: imagePost,
             personImage: personImage
         )
         Articals.append(newPost)
      }
    
    // Delete a post by its ID
    func deleteArtical(id: UUID) {
        Articals.removeAll { $0.id == id }
    }
    
    // Edit an existing post by its ID
    func editArical(id: UUID, newDescription: String? = nil, newName: String? = nil, newUserName: String? = nil, newAddTime: String? = nil, newImagePost: String? = nil, newPersonImage: String? = nil) {
        guard let index = Articals.firstIndex(where: { $0.id == id }) else { return }
        
        Articals[index].description = newDescription ?? Articals[index].description
        Articals[index].name = newName ?? Articals[index].name
        Articals[index].userName = newUserName ?? Articals[index].userName
        Articals[index].addTime = newAddTime ?? Articals[index].addTime
        Articals[index].imagePost = newImagePost ?? Articals[index].imagePost
        Articals[index].personImage = newPersonImage ?? Articals[index].personImage
    }
    


    func toggleLike() {
        stateLike.toggle()
    }

    func toggleSave() {
        stateSave.toggle()
    }

    func toggleCommentView() {
        showCommentView.toggle()
    }

    func toggleShareSheet() {
        showShareSheet.toggle()
    }
}



/// A wrapper for `UIImage` that conforms to `Transferable`.
struct ImageTransferable: Transferable {
    let image: UIImage
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw ImageTransferableError.importFailed
            }
            return ImageTransferable(image: uiImage)
        }
    }
}

// Custom Error for Transferable
enum ImageTransferableError: Error {
    case importFailed
}
