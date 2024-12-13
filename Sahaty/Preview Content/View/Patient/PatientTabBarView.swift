//
//  PatientDashboardView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI

struct PatientTabBarView: View {
    
    @State var selectedPage = 0

    var body: some View {
        
        TabView(selection: $selectedPage){

            Text("الاعدادات")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            .tabItem{
                HStack{
                    Text("الاعدادات")
                    Image(systemName: "gear")
                }
            }
            .tag(4)
            
            
                Text("الاطباء")
                    .tabItem{
                        HStack{
                            Text("الاطباء")
                            Image(systemName: "person.2")
                        }
                    }
                    .tag(1)

            
            Text("الاشعارات")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            .tabItem{
                HStack{
                    Text("الاشعارات")
                    Image(systemName: "heart.fill")
                }
            }
            .tag(2)
            .badge(5)
    
        
            Text("الملف الشخصي")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            .tabItem{
                HStack{
                    Text("الملف الشخصي")
                    Image(systemName: "person.fill")
                }
            }
            .tag(3)
            
            PationtHomeScreen()
                    .tabItem{
                        HStack{
                            Text("الرئيسية")
                            Image(systemName: "house.fill")
                        }
                    }
                    .tag(0)

            
            }
        
    }
}

#Preview{
    PatientTabBarView()
}


