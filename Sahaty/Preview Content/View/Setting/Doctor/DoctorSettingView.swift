//
//  PatientSettingView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//


import SwiftUI
import PhotosUI

struct DoctorSettingView: View {
    
    var viewModel : ProfileViewModel
    
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showImagePicker = false
    @State private var showNotificationView = false
    @State private var showNotificationToggle = false
    @State private var showSavedView = false
    @State private var showRestPasswordView = false
    @State private var showLogoutAleart = false
        
    

    var body: some View {
        // Header Section
        NavigationStack {
            VStack{
                
                // Header Section
                ProfileHeaderView(viewModel: viewModel, selectedImage: $selectedImage, showImagePicker: $showImagePicker)
                    .photosPicker(isPresented: $showImagePicker, selection: $selectedImageItem)
                    .onChange(of: selectedImageItem) { _, newValue in
                        loadImage(newValue)
                    }
                
                NavigationLink("تعديل الملف الشخصي", destination: EditDoctorDataProfileView(viewModel: viewModel))
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.accentColor)
                    .cornerRadius(15)
                    .padding(.vertical)
                Divider()
                
                VStack(spacing:20){
                    MenuOption(title: "ادارة الاشعارات", icon: "bell", action: {showNotificationView.toggle()})
                        .sheet(isPresented: $showNotificationView) {
                            
                            Toggle(isOn: $showNotificationToggle){
                                Text("تفعيل الاشعارات")
                                    .font(.headline)
                                    .foregroundStyle(.accent)
                            }
                            .tint(.accent)
                            .padding()
                            .presentationDetents([.fraction(0.1)])
                            .presentationCornerRadius(30)
                   
                        }
                    MenuOption(title: "تغير كلمة المرور", icon: "key", action: {showRestPasswordView.toggle()})
                        .sheet(isPresented: $showRestPasswordView) {
                            changePasswordView(userType: .doctor)
                                .presentationDetents([.fraction(0.65)])
                                .presentationCornerRadius(30)
                        }
                    
                    MenuOption(title: "تسجيل الخروج", icon: "arrowshape.turn.up.left", action: {showLogoutAleart.toggle()})
                        .alert("هل انت متاكد من انك تريد مغادرة الحساب؟", isPresented: $showLogoutAleart){
                              Button("موافق", role: .destructive) {}
                              Button("إلغاء", role: .cancel) {}
                                }
                }
            

                Spacer()
            }
            .padding()
            .navigationBarTitle("الملف الشخصي")
            .navigationBarTitleDisplayMode(.inline)
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
    DoctorSettingView(viewModel: ProfileViewModel(doctor: DoctorModel(fullName: "محمد أشرف", email: "mido@gmail.com", specialization: "طب عيون", licenseNumber: "", articlesCount: 0, advicesCount: 0, followersCount: 0,articles: [], advices: [], comments: [], likedArticles: [])))
    
}
