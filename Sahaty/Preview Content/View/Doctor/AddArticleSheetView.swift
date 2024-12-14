//
//  AddArticleSheetView.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//

import SwiftUI

struct AddArticleSheetView: View {
    @State private var textArtical: String = ""
    @State private var uploadedImage : Bool  = false
    var body: some View {
        
        VStack(spacing: 0){
            
            Text("أنشئ منشور جديد!")
                .font(.title)
                .padding(.vertical)
            HStack{
                Button {
                    uploadedImage.toggle()
                } label: {
                    Image(systemName: "icloud.and.arrow.up")
                }
                Spacer()
                Text("الموضوع")
                Image(systemName: "text.book.closed")
                
            

            }
            .padding(.horizontal,20)
            .padding(.bottom,20)

            .foregroundStyle(.secondary)
            TextEditor(text: $textArtical)
                .frame(height: 200)
                .colorMultiply(Color(.secondarySystemBackground))
                .cornerRadius(25)
                .multilineTextAlignment(.trailing)
            
            RoundedRectangle(cornerRadius: 25)
                .frame(height: 160)
                .foregroundStyle(Color(.secondarySystemBackground))
                .multilineTextAlignment(.trailing)
                .padding(.top,-30)
                .padding(.bottom)
                .overlay {
                    if uploadedImage{
                        Image("post")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(10)
                    }
                }

            
            Button {
                
                
            } label: {
                    Text("نشر")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal,10)
                    .background(Color(.accent))
                    .cornerRadius(10)
                    .padding(.top)
                
                
            }



        }
        .padding()
    }
}

#Preview {
    AddArticleSheetView()
}
