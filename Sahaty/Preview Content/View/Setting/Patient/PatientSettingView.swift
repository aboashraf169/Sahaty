//
//  SettingView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI
import PhotosUI


// MARK: - ProfileHeaderView

struct PatientSettingView: View {
    
    var viewModel  = PatiantModel.defaultData
    @AppStorage("isDarkModePatient") private var isDarkModePatient = false // حفظ الاختيار

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


                
                NavigationLink("تعديل الملف الشخصي", destination: EditPationtDataProfileView())
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
                    MenuOption(title: "العناصر المحفوظة", icon: "bookmark", action: {showSavedView.toggle()})
                        .sheet(isPresented: $showSavedView) {
                            patientSavedArticalvView()
            
                        }
                    MenuOption(title: "تغير كلمة المرور", icon: "key", action: {showRestPasswordView.toggle()})
                        .sheet(isPresented: $showRestPasswordView) {
                            changePasswordView(userType: .patient)
                                .presentationDetents([.fraction(0.65)])
                                .presentationCornerRadius(30)
                        }
                    
                    MenuOption(title: "تسجيل الخروج", icon: "arrowshape.turn.up.left", action: {showLogoutAleart.toggle()})
                        .alert("هل انت متاكد من انك تريد مغادرة الحساب؟", isPresented: $showLogoutAleart){
                              Button("موافق", role: .destructive) {}
                              Button("إلغاء", role: .cancel) {}
                                }
                    
                    Toggle(isOn: $isDarkModePatient) {
                                HStack {
                                    Image(systemName: isDarkModePatient ? "moon.fill" : "sun.max.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 50, height: 50)
                                        .background(Color.accentColor.opacity(0.2)).cornerRadius(10)

                                    Text("الوضع الليلي")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 8)

                           }
                    .toggleStyle(SwitchToggleStyle(tint: .accent)) // تخصيص لون التبديل
                    .frame(maxWidth: .infinity)
                    .padding(0)
                    
                }
            

                Spacer()
            }
            .padding()
            .navigationBarTitle("الملف الشخصي")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(isDarkModePatient ? .dark : .light) // تطبيق المظهر

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
    PatientSettingView()
    
}
