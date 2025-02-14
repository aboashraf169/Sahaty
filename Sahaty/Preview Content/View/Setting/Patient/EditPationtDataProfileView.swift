//
//  EditDoctorDataProfileView.swift
//  Sahaty
//
//  Created by mido mj on 12/25/24.
//



import SwiftUI
import PhotosUI

struct EditPationtDataProfileView: View {
    
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showImagePicker = false
    
    @State private var viewModel = PatiantModel.defaultData
    var body: some View {
        VStack(spacing: 20) {
            // Profile Picture
            VStack() {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else if let image = viewModel.profilePicture {
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.accentColor)
                            .shadow(radius: 5)
                        
                    }
                    Button {
                        showImagePicker.toggle()
                    } label: {
                        Image(systemName: "camera.fill")
                            .foregroundStyle(Color.white)
                            .padding(8)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }
                    .offset(x: -40, y: 40)
                    
         
                }
                
                Text(viewModel.fullName)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(viewModel.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
                .photosPicker(isPresented: $showImagePicker, selection: $selectedImageItem)
                .onChange(of: selectedImageItem) { _, newValue in
                    loadImage(newValue)
                }
            
            Divider()
        ScrollView{
                            
                EditField(title: "الاسم", text : $viewModel.fullName)
        
                EditField(title: "البريد الإلكتروني", text: $viewModel.email)
            
            
                
            }
            
            // Save Button
            Button(action: {
                viewModel.fullName = viewModel.fullName
            }) {
                Text("حفظ التغييرات")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(10)
            }
            .padding()

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
    
    struct EditField: View {
        
        let title: String
        @Binding var text: String
        var body: some View {
            VStack(alignment: .leading,spacing: 0) {
                Text(title)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                TextField("لا يوجد نص متوفر", text: $text)
                    .font(.callout)
                    .padding()
                    .background(Color(.systemGray6))
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .cornerRadius(10)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical,7)
            .padding(.horizontal)
        }
    }
}


#Preview {
    EditPationtDataProfileView()
    
}
