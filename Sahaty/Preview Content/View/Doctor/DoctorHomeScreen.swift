
//
//  testScreen.swift
//  Sahaty
//
//  Created by mido mj on 12/12/24.
//

import SwiftUI


struct DoctorHomeScreen: View {
    // نصيحة
    @State private var advice : String = "اشرب 8 أكواب ماء يوميًا للحفاظ على ترطيب جسمك"
    @State private var description : String = "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار."
    @State private var name : String = "محمد أشرف"
    @State private var userName : String = "midoMj@"
    @State private var addTime : String = "ساعتين"


    var body: some View {
        NavigationStack{
            
// MARK: - Header Section
    VStack{
            // قسم البحث واضافة المقال والصورة الشخصية
        HeaderHomeSectionView()
        
// MARK: - Center Section
            
            // اضافة نصيحة
            HStack {
                Spacer()
                Text("نصائح اليوم")
                    .font(.headline)
                    .fontWeight(.regular)
                Button {
                    // ظهور شاشة اضافة النصيحة
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width:20,height: 20)
                        .foregroundStyle(.black)
                }
                
            }
            .padding(.horizontal,20)
            .padding(.bottom,10)
            
            // النصائح
        ScrollView(.vertical,showsIndicators: true){
                AdviceScetion(advice: advice)
                AdviceScetion(advice: description)
                AdviceScetion(advice: advice)
                AdviceScetion(advice: description)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
    

            // عنوان المنشور
            titleCategory(title: "منشورات جديدة")
            
            // المنشور
            ScrollView(.vertical,showsIndicators: false){
                ShowPost(description: description, name: name, userName: userName, addTime: addTime)
                ShowPost(description: description, name: name, userName: userName, addTime: addTime)
                ShowPost(description: description, name: name, userName: userName, addTime: addTime)
                ShowPost(description: description, name: name, userName: userName, addTime: addTime)
            }
                }
            }
        }
    
}



#Preview {
    DoctorHomeScreen()
}

struct AdviceScetion: View {
     var advice : String
    var body: some View {
            HStack{
                
                Button(action: {
                    
                }) {
                    Image(systemName: "trash")
                        .foregroundStyle(.black)
                }
                    .padding(.trailing)
                Button(action: {
                    
                }) {
                    Image(systemName: "pencil")
                        .foregroundStyle(.black)

                }
                
                Spacer()
                Text(advice)
                    .font(.caption)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(4)
                    .opacity(0.5)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 5,height: 20)
                    .foregroundStyle(.accent)
            }
            .padding(.top,10)
            .padding(.leading)
            .padding(.trailing,40)
    }
}




