//
//  PatientDashboardView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI

struct PatientTabBarView: View {
    
    @StateObject var appState = AppState()
    
    @State var Patient : PatiantModel =  PatiantModel.defaultData

    var body: some View {
        
        TabView(selection: $appState.selectedTabPatients){

            PatientHomeScreen()
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


            
            NotificationsView()
            .tabItem{
                HStack{
                    Text("الاشعارات")
                    Image(systemName: "heart.fill")
                }
            }
            .tag(TabPatient.Notificatons)
            .badge(5)
    
            
           
            
            
            PatientSettingView(viewModel: Patient)
                .padding()
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


