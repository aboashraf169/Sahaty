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
                            Text("الرئيسية")
                            Image(systemName: "house.fill")
                        }
                    }
                    .tag(TabDoctor.home)
            
            
                 ProfileView(viewModel: DoctorProfileViewModel(doctor: doctor))
                 .tabItem{
                     HStack{
                         Text("الملف الشخصي")
                         Image(systemName: "person.fill")
                     }
                 }
                 .tag(TabDoctor.profile)

            
                Text("المحادثات")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                .tabItem{
                    HStack{
                        Text("المحادثات")
                        Image(systemName: "message")
                    }
                }
                .tag(TabDoctor.chat)
                .badge(3)

            
            NotificationsView()
            .tabItem{
                HStack{
                    Text("الاشعارات")
                    Image(systemName: "heart.fill")
                }
            }
            .tag(TabDoctor.Notificatons)
            .badge(10)
    
    
            DoctorSettingView(viewModel: DoctorProfileViewModel(doctor: doctor))
                .padding()
            .tabItem{
                HStack{
                    Text("الاعدادات")
                    Image(systemName: "gear")
                }
            }
            .tag(TabDoctor.settings)
  
            }
        .environmentObject(appState) // مشاركة حالة التطبيق مع جميع الشاشات

        
    }
    
}

#Preview{
    let appState = AppState()
    DoctorTabBarView()
        .environmentObject(appState)
}


