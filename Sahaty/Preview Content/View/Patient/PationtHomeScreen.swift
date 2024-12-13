//
//  testScreen.swift
//  Sahaty
//
//  Created by mido mj on 12/12/24.
//

import SwiftUI


struct PationtHomeScreen: View {
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
        
        HeaderHomeSectionView()
        
        
// MARK: - Center Section
        ScrollView(.vertical,showsIndicators: false){
            
            // اضافة نصيحة
            titleCategory(title: "نصائح اليوم")
            
            // النصائح
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .foregroundStyle(.accent)
                .overlay {
                    HStack{
                        Spacer()
                        // تستخدم لجعل النص في سطر واحد وتصغير حسب الحاجة
                        ViewThatFits{
                            Text("\"\(advice)\"")
                                .font(.callout)
                                .foregroundStyle(.white)
                        }
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        Image("idea")
                    }
                    .padding()
                }
            
            // عنوان التصنيفات
            titleCategory(title: "التصنفات")

            
            // التصنيفات
            ScrollView(.horizontal,showsIndicators: false) {
                HStack{
                    Category(title: "الصحة النفسية", imageName: "face.smiling")
                    Category(title: "الأمراض المزمنة", imageName: "arrow.clockwise.heart")
                    Category(title: "التغذية الصحية", imageName: "fork.knife.circle")
                    Category(title: "الصحة النفسية", imageName: "face.smiling")
                    Category(title: "الأمراض المزمنة", imageName: "arrow.clockwise.heart")
                    Category(title: "التغذية الصحية", imageName: "fork.knife.circle")
                }
                .padding(.horizontal)
            }
            
            
            // عنوان المنشور
            titleCategory(title: "منشورات جديدة")

            
            
            // المنشور
            ShowPost(description: description, name: name, userName: userName, addTime: addTime,imagePost: nil)
            ShowPost(description: description, name: name, userName: userName, addTime: addTime,imagePost: nil)
            ShowPost(description: description, name: name, userName: userName, addTime: addTime,imagePost: nil)
            ShowPost(description: description, name: name, userName: userName, addTime: addTime,imagePost: nil)

                }
            }
        }
    }
}


struct Category : View {
    
    var title : String
    var imageName : String
    
    var body: some View {
        Button{
            
        }label : {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.light)
                    .frame(width: .infinity)
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
                    .fontWeight(.light)
            }
            .opacity(0.8)
            .padding()
            .frame(width: 170,height: 50)
            .foregroundStyle(.black)
            .background(Color(.systemGray6)).cornerRadius(10)
        }
    
    }
}



#Preview {
    PationtHomeScreen()
}

struct titleCategory: View {
    var title: String
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
                .padding(.horizontal,20)
                .padding(.top,15)
        }
    }
}
