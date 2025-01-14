//
//  PatientSettingView.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//


import SwiftUI
import PhotosUI

struct DoctorSettingView: View {
    
    var viewModel : DoctorProfileViewModel
    
    @State private var selectedImage: UIImage? = nil
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var showImagePicker = false
    @State private var showNotificationView = false
    @State private var showNotificationToggle = false
    @State private var showSavedView = false
    @State private var showRestPasswordView = false
    @State private var showLogoutAleart = false
    
    @AppStorage("isDarkModeDoctor") private var isDarkModeDoctor = false // حفظ الاختيار
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة


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
                
                NavigationLink("edit_profile".localized(), destination: EditDoctorDataProfileView())
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.accentColor)
                    .cornerRadius(15)
                    .padding(.vertical)
                               
                Divider()
                
                VStack(spacing:20){
                    MenuOption(title: "manage_notifications".localized(), icon: "bell", action: { showNotificationView.toggle() })
                        .sheet(isPresented: $showNotificationView) {
                            
                            Toggle(isOn: $showNotificationToggle){
                                Text("enable_notifications".localized())
                                    .font(.headline)
                                    .foregroundStyle(.accent)
                            }
                            .tint(.accent)
                            .padding()
                            .presentationDetents([.fraction(0.1)])
                            .presentationCornerRadius(30)
                   
                        }
                    MenuOption(title: "change_password".localized(), icon: "key", action: { showRestPasswordView.toggle() })
                        .sheet(isPresented: $showRestPasswordView) {
                            changePasswordView(usersType: .doctor)
                                .presentationDetents([.fraction(0.65)])
                                .presentationCornerRadius(30)
                        }
                    
                    MenuOption(title: "logout".localized(), icon:    "arrowshape.turn.up.left", action: { showLogoutAleart.toggle() })
                        .alert("confirm_logout".localized(), isPresented: $showLogoutAleart) {
                            Button("confirm".localized(), role: .destructive) {
                                logout()
                            }
                            Button("cancel".localized(), role: .cancel) {}
                        }
                    Toggle(isOn: $isDarkModeDoctor) {
                                HStack {
                                    Image(systemName: isDarkModeDoctor ? "moon.fill" : "sun.max.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 50, height: 50)
                                        .background(Color.accentColor.opacity(0.2)).cornerRadius(10)

                                    Text("dark_mode".localized())
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
            .navigationBarTitle("profile".localized())
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(isDarkModeDoctor ? .dark : .light) // تطبيق المظهر
        }
        .direction(appLanguage) // ضبط اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة
       
        
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

func logout() {
    // إزالة التوكن
    APIManager.shared.setBearerToken("") // مسح التوكن
    let isTokenDeleted = KeychainManager.shared.deleteToken()

    if isTokenDeleted {
        print("Token deleted successfully.")
        // قم بتوجيه المستخدم إلى شاشة تسجيل الدخول
    } else {
        print("Failed to delete token.")
        // التعامل مع الخطأ إذا لزم الأمر
    }
    // إعادة التوجيه إلى شاشة تسجيل الدخول
    if let window = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .flatMap({ $0.windows })
        .first(where: { $0.isKeyWindow }) {
        window.rootViewController = UIHostingController(rootView: LoginView())
        window.makeKeyAndVisible()
    }
}


#Preview {
    DoctorSettingView(viewModel: DoctorProfileViewModel(doctor: DoctorModel(fullName: "محمد أشرف", email: "mido@gmail.com", specialization: "طب عيون", licenseNumber: "", articlesCount: 0, advicesCount: 0, followersCount: 0,articles: [], advices: [], comments: [], likedArticles: [])))
    
}
