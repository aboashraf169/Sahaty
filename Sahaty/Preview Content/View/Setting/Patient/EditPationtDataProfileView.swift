//
//  EditDoctorDataProfileView.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.
//



import SwiftUI
import PhotosUI

struct EditPationtDataProfileView: View {
    
    var viewModel : PatientModel
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showImagePicker = false
        
    var body: some View {
        VStack{
            // Header Section
            PicturePatientSetting(viewModel: viewModel,selectedImage: $selectedImage, showImagePicker: $showImagePicker)
                .photosPicker(isPresented: $showImagePicker, selection: $selectedImageItem)
                .onChange(of: selectedImageItem) { _, newValue in
                    loadImage(newValue)
                }
            Text("محمد أشرف")
                .font(.headline)
                .fontWeight(.medium)
            
            Text("Mido@mj")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                        
            Spacer()
            
        }
        .padding(.vertical)

     
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
    EditPationtDataProfileView(viewModel: PatientModel(
        id: UUID(),
        fullName: "محمد علي",
        email: "patient@example.com",
        profilePicture: "post",
        followedDoctors: [],
        favoriteArticles: [],
        favoriteAdvices: [],
        likedArticles: [],
        articleComments: []
    ))
    
}
