
//
//  testScreen.swift
//  Sahaty
//
//  Created by mido mj on 12/12/24.
//

import SwiftUI


struct DoctorHomeScreen: View {
    // نصيحة
    @StateObject  var adviceViewModel = AdviceViewModel()
    @StateObject  var articalsViewModel = ArticalsViewModel()

    @State private var advice : String = "اشرب 8 أكواب ماء يوميًا للحفاظ على ترطيب جسمك"
    @State private var description : String = "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار."
    @State private var name : String = "محمد أشرف"
    @State private var userName : String = "midoMj@"
    @State private var addTime : String = "ساعتين"
    @State private var showAddAdviceView : Bool  = false
    @State private var showAddArticalView : Bool  = false


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
                    if !adviceViewModel.Advicies.isEmpty{
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
                }
                .padding(.horizontal,20)
                .padding(.bottom,10)
                .sheet(isPresented: $showAddAdviceView){
                    AddAdviceSheetView(viewModel: adviceViewModel)
                        .presentationDetents([.fraction(0.45)])
                        .presentationCornerRadius(30)
                    
                    
                }
                
                if adviceViewModel.Advicies.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "lightbulb.slash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.7))

                        Text("لا توجد نصائح حتى الآن!")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)

                        Text("ابدأ بإضافة نصيحة جديدة لتحفيز الآخرين.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        // زر صغير مع أيقونة فقط
                        Button(action: {
                            showAddAdviceView.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.accentColor)
                        }
                        .padding(.bottom, 20)
                    }
                    .padding(.top)
                } else {
                    List {
                        ForEach(adviceViewModel.Advicies) { advice in
                            AdviceView(advice: advice)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    swipeActions(for: advice)
                                }
                        }
                    }
                    .listStyle(.plain)
                    .frame(height: 120)
                }


                
                
                // عنوان المنشور
                titleCategory(title: "مقالة جديدة")
                
                // المنشور
                NavigationStack {
                    if $articalsViewModel.Articals.isEmpty {
                        // Show "No Data" View
                        VStack {
                            Image(systemName: "tray")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray.opacity(0.7))
                            Text("لا توجد مقالات حاليًا")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)

                            Text("ابدأ بإضافة مقالة جديدة لمساعدة الآخرين.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            Button(action: {
                                showAddArticalView.toggle()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color.accentColor)
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.top)
                    }else{
                        List {
                            ForEach(articalsViewModel.Articals) {article in
                                ShowArtical(artical: article)
                            }
                        }
                        .listStyle(.inset)
                    }
                }
                .sheet(isPresented: $showAddArticalView){
                    AddArticleSheetView(articalsViewModel: articalsViewModel)
                    
                    .presentationDetents([.fraction(0.8)])
                    .presentationCornerRadius(30)
                    
                    
                }
                
                Spacer()
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








