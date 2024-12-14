//
//  SwiftUIView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI

struct ShowPost : View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
      var description : String
      var name : String
      var userName : String
      var addTime : String
      var imagePost : String? = nil
      var personImage : String? = nil

    
    var body: some View {
        
        VStack(spacing: 20){
            
            HStack{
                // اعدادات المنشور
                if viewModel.model.userType != .doctor
                {
                    Menu("", systemImage: "ellipsis") {
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("حذف المنشور")
                                    }

                        }
                        Button {
                            
                        } label: {
                            HStack {
                                Image(systemName: "pencil")
                                Text("تعديل المنشور")
                                    }

                        }
                    }
                    .foregroundStyle(.black)
                }
              
                Spacer()
                
                // بيانات صاحب المنشور
                VStack(alignment: .trailing){
                    Text("د.\(name)")
                        .font(.headline)
                        .fontWeight(.regular)
                    
                    HStack {
                        Text("منذ \(addTime)")
                            .font(.subheadline)
                            .fontWeight(.light)
                        
                        Text(userName)
                            .font(.subheadline)
                            .fontWeight(.light)
                    }.opacity(0.6)
                }
                .padding(.horizontal,5)
                
                
                // صورة صاحب المنشور
                if let image = personImage {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal,7)
                        .frame(width: 40,height: 40)
                        .cornerRadius(20)
                }else{
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .padding(.horizontal,7)
                        .frame(width: 40,height: 40)
                        .background(Color.accentColor)
                        .cornerRadius(20)
                }
           
        
                }
            
                // وصف المنشور
                Text(description)
                    .font(.callout)
                    .fontWeight(.light)
                    .multilineTextAlignment(.trailing)
            
            
                 // صورة المنشور
                Rectangle()
                     .frame(maxWidth: .infinity)
                     .frame(maxHeight: .infinity)
                     .foregroundStyle(Color(.systemGray6)).opacity(0.4)
                     .cornerRadius(10)
                .overlay {
                    if let image = imagePost {
                        Image(image)
                        .resizable()
                        .frame(width: 250,height: 200)
                        .cornerRadius(25)
                    }else{
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .foregroundStyle(.accent)
                                .frame(width: 100,height: 100)
                            Text("No Image")
                                .foregroundStyle(.accent)
                        }
                    }
                  
                }
            
            
                // خيارات المنشور
            FotterPost()
            
                
             
        }
        .frame(maxWidth: .infinity)
        .frame(height: 350)
        .padding(.vertical,10)
        .padding(.horizontal)
        
    }
}
#Preview {
    
    ShowPost(description:  "السكري حالة شائعة يمكن التحكم بها عبر نظام غذائي متوازن، ممارسة الرياضة بانتظام، ومراقبة مستوى السكر باستمرار.", name: "محمد اشرف", userName: "midoMj@", addTime: "ساعتين")
}

struct FotterPost: View {
    @State private var stateLike = false
    @State private var stateSave = false
    @State private var showCommentView = false
    @State private var showShereSheet = false



    var body: some View {
        VStack {
            HStack(spacing: 30){
                
                Button {
                    stateSave.toggle()
                } label: {
                    if !stateSave {
                        Image(systemName: "bookmark")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.black)
                    }else{
                        Image(systemName: "bookmark.fill")
                            .foregroundStyle(.accent)
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.black)
                    }
                }
                
                Spacer()
                                
                Button {
                    showShereSheet.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(.black)
                }
                Button {
                    showCommentView.toggle()
                } label: {
                    Image(systemName: "message")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(.black)
                }
                Button {
                    stateLike.toggle()
                    
                } label: {
                    if !stateLike {
                        Image(systemName: "heart")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.black)
                    }else{
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.accent)
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.black)
                    }
               
                }
            }
            .actionSheet(isPresented: $showShereSheet){
                getActionSheet()
            }
            .sheet(isPresented: $showCommentView){
                CommentScreen()
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.7)])
            }
            
            //خط فاصل
            Divider()
                .padding(.top,5)
        }
    }
    
    func getActionSheet() -> ActionSheet {
        
        let title = Text("ماذا تريد ان تفعل")
        let ShereButton : ActionSheet.Button =  .default(Text("مشاركة")){
            
        }
        
        let CancelButton : ActionSheet.Button = .cancel(Text("الغاء"))
        
    
            return  ActionSheet(
                title: title,
                message: Text("") ,
                buttons: [ShereButton,CancelButton]
            )
        
        }

}
