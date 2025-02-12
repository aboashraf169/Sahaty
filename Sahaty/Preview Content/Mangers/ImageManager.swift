//
//  ImageUploader.swift
//  Sahaty
//
//  Created by mido mj on 1/29/25.
//


import Foundation
import SwiftUI
import UIKit


class ImageManager {
    
    static let shared = ImageManager()
    private let baseURL = "http://127.0.0.1:8000/"
    

    
    // MARK: - Function to upload an image
    func uploadImage(image: UIImage, url: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let imageData = image.jpegData(compressionQuality: 0.9) else {
            completion(.failure(NSError(domain: "Invalid Image", code: 0, userInfo: nil)))
            return
        }
        
        guard let uploadURL = URL(string: url) else {
            print("Error: Invalid URL")
            return
        }
        
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        
        // Add image data to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"img\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body

        // Start the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data,
                      let responseString = String(data: data, encoding: .utf8) else {
                    completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                    return
                }
                completion(.success(responseString)) // Assuming the server returns the image URL
            }
        }.resume()
    }
    
    
    // MARK: - Function to fetch an image from server
    func fetchImage(imagePath: String, completion: @escaping (UIImage?) -> Void) {
        let fullImageURL = imagePath
//        self.baseURL + 
        guard let url = URL(string: fullImageURL) else {
            print("Error: Invalid Image URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                
                // 1) تحقق من وجود خطأ اتصال
                if let error = error {
                    print("Failed to fetch image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                // 2) تحقق من كود الاستجابة
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code:", httpResponse.statusCode)
                    if httpResponse.statusCode != 200 {
                        print("Server returned non-200 status code")
                        completion(nil)
                        return
                    }
                }
                
                // 3) تحقق من أن البيانات غير فارغة
                guard let data = data else {
                    print("No data returned from server")
                    completion(nil)
                    return
                }
                
                // 4) طباعة البيانات كـ نص للمساعدة في التشخيص
                if let debugString = String(data: data, encoding: .utf8) {
                    print("Response Data Debug:\n\(debugString)")
                }
                
                // 5) محاولة تحويل البيانات إلى UIImage
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("Error: Image data is invalid")
                    completion(nil)
                }
            }
        }.resume()
    }


}


struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
