//
//  DoctorDashboardView.swift
//  Sahaty
//
//  Created by mido mj on 12/10/24.
//


import SwiftUI
// واجهة قيد الانشاء
struct DoctorTabBarView: View {
    @StateObject var appState = AppState()
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    @State var doctor = DoctorModel(
        fullName: "د. محمد أشرف",
        email: "doctor@example.com",
        specialization: "طب الأطفال",
        licenseNumber: "12345",
        profilePicture: nil,
        biography: nil,
        articlesCount: 10,
        advicesCount: 20,
        followersCount: 50,
        articles: [],
        advices: [],
        comments: [],
        likedArticles: []
    )


    var body: some View {
        
        TabView(selection: $appState.selectedTabDoctors){

            DoctorHomeScreen(doctor: doctor)
                    .tabItem{
                        HStack{
                            Text(("Home").localized())
                            Image(systemName: "house.fill")
                        }
                    }
                    .tag(TabDoctor.home)
            
            
                 ProfileView(viewModel: DoctorProfileViewModel(doctor: doctor))
                 .tabItem{
                     HStack{
                         Text("Profile".localized())
                         Image(systemName: "person.fill")
                     }
                 }
                 .tag(TabDoctor.profile)

        
            Text("Chats".localized())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                .tabItem{
                    HStack{
                        Text("Chats".localized())
                        Image(systemName: "message")
                    }
                }
                .tag(TabDoctor.chat)
                .badge(3)

            
            NotificationsView()
            .tabItem{
                HStack{
                    Text("Notifications".localized())
                    Image(systemName: "heart.fill")
                }
            }
            .tag(TabDoctor.Notificatons)
            .badge(10)
    
    
            DoctorSettingView(viewModel: DoctorProfileViewModel(doctor: doctor))
                .padding()
            .tabItem{
                HStack{
                    Text("Settings".localized())
                    Image(systemName: "gear")
                }
            }
            .tag(TabDoctor.settings)
  
            }
        .environmentObject(appState) // مشاركة حالة التطبيق مع جميع الشاشات
        .direction(appLanguage) // اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة

        
    }
    
}

#Preview{
    let appState = AppState()
    DoctorTabBarView()
        .environmentObject(appState)
}


