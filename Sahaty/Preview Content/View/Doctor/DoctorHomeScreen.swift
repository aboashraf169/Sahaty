
//
//  testScreen.swift
//  Sahaty
//
//  Created by mido mj on 12/12/24.
//

import SwiftUI


struct DoctorHomeScreen: View {
    // نصيحة
    @StateObject private var adviceViewModel = AdviceViewModel()
    @State private var advice : String = "اشرب 8 أكواب ماء يوميًا للحفاظ على ترطيب جسمك"
    @State private var description : String = "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار."
    @State private var name : String = "محمد أشرف"
    @State private var userName : String = "midoMj@"
    @State private var addTime : String = "ساعتين"
    @State private var showAddAdviceView : Bool  = false

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
                    showAddAdviceView.toggle()

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
            .sheet(isPresented: $showAddAdviceView){
                AddAdviceSheetView()
                    .presentationDetents([.fraction(0.45)])
                    .presentationCornerRadius(30)

                    
            }
            
            // النصائح
            List {
                ForEach(adviceViewModel.Advicies) { advice in
                    AdviceView(advice: advice)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            swipeActions(for: advice)
                        }
                }
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(.horizontal)
    

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
    func swipeActions(for advice: AdviceModel) -> some View {
       Group {
           // Edit Action
           Button {
               adviceViewModel.startEditing(advice: advice)
           } label: {
               Label("تعديل", systemImage: "pencil")
           }
           .tint(.blue)
           
           // Delete Action
           Button() {
               if let index = adviceViewModel.Advicies.firstIndex(where: { $0.id == advice.id }) {
                   adviceViewModel.deleteAdvice(at: IndexSet(integer: index))
               }
           } label: {
               Label("حذف", systemImage: "trash")
           }
           .tint(.red)
       }
   }
    
}




#Preview {
    DoctorHomeScreen()
}








