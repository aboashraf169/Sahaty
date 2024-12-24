//
//  EditProfileView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI
import PhotosUI

struct EditDoctorDataProfileView: View {
    
    var viewModel : ProfileViewModel
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showImagePicker = false
        
    var body: some View {
        VStack{
            // Header Section
            ProfileHeaderView(viewModel: viewModel, selectedImage: $selectedImage, showImagePicker: $showImagePicker)
                .photosPicker(isPresented: $showImagePicker, selection: $selectedImageItem)
                .onChange(of: selectedImageItem) { _, newValue in
                    loadImage(newValue)
                }
                        
            Spacer()
            
        }
        .padding(.vertical)

     
    }
    
    // MARK: - Field View
    private func fieldView(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)
            
            TextField(placeholder, text: text)
                .font(.callout)
                .padding()
                .background(Color(.systemGray6))
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .cornerRadius(10)
                .multilineTextAlignment(.leading)
        }
    }
    
    private func loadImage(_ item: PhotosPickerItem?) {
        if let item = item {
            item.loadTransferable(type: ImageTransferable.self) { result in
                switch result {
                case .success(let image):
                    if let image = image {
                        selectedImage = image.image
                    }
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    EditDoctorDataProfileView(viewModel: ProfileViewModel(doctor: DoctorModel(fullName: "د.محمد أشرف", email: "mido@gmail.com", specialization: "طب عيون", licenseNumber: "23424343", articlesCount: 0, advicesCount: 0, followersCount: 0, articles: [], advices: [], comments: [], likedArticles: [])))
}
