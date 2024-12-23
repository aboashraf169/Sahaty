//
//  PatientDashboardView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI

struct PatientTabBarView: View {
    
    @StateObject var appState = AppState()


    var body: some View {
        
        TabView(selection: $appState.selectedTabPatients){

            PatientHomeScreen(patient: PatientModel(user: UserModel(fullName: "", email: "", userType: .patient)))
                    .tabItem{
                        HStack{
                            Text("الرئيسية")
                            Image(systemName: "house.fill")
                        }
                    }
                    .tag(TabPatient.home)

   
            
            
            SpecializationsDoctorsView()
                    .tabItem{
                        HStack{
                            Text("الاطباء")
                            Image(systemName: "person.2")
                        }
                    }
                    .tag(TabPatient.Doctors)


            Text("المحادثات")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            .tabItem{
                HStack{
                    Text("المحادثات")
                    Image(systemName: "message")
                }
            }
            .tag(TabPatient.chat)
            .badge(3)

            Text("الاشعارات")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            .tabItem{
                HStack{
                    Text("الاشعارات")
                    Image(systemName: "heart.fill")
                }
            }
            .tag(TabPatient.Notificatons)
            .badge(5)
    
            
           
            
            
            Text("الاعدادات")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            .tabItem{
                HStack{
                    Text("الاعدادات")
                    Image(systemName: "gear")
                }
            }
            .tag(TabPatient.settings)

            
            
   
            }
        .environmentObject(appState) // مشاركة حالة التطبيق مع جميع الشاشات

        
    }
}

#Preview{
    PatientTabBarView()
}


