//
//  HeaderHomeSectionView.swift
//  Sahaty
//
//  Created by mido mj on 12/13/24.
//

import SwiftUI

struct HeaderHomeSectionView: View {
    @StateObject private var ViewModel = AuthenticationViewModel()
    @State private var showAddArticleSheet = false
    var body: some View {
        HStack{
//            if ViewModel.model.userType != .patient {
                // ظهور شاشة اضافة مقال جديد
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 50)
                    .frame(height: 40)
                    .foregroundStyle(Color(.systemGray6))
                    .overlay {
                        Button {
                            showAddArticleSheet.toggle()
                        } label: {
                            Image(systemName: "text.badge.plus")
                                .scaledToFit()
                                .foregroundStyle(.black)
                        }
                        
                    }
//            }
            // صندوق البحث
            RoundedRectangle(cornerRadius: 15)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .foregroundStyle(Color(.systemGray6))
                .overlay {
                    HStack{
                        Button {
                            // عمل فلتر للبحث
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                                .foregroundStyle(.black)
                        }
                        Spacer()
                        Text("ابحث عن الواجهة")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        Button {
                            // عمل بحث
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.black)
                        }
                        
                        
                    }
                    .padding()
                }
                .onTapGesture {
                    
                }
            
            // صورة الشخصية
            Button {
            } label: {
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
        .padding(.horizontal)
        .padding(.bottom,20)
        .padding(.top,20)
        .sheet(isPresented: $showAddArticleSheet) {
//            CommentScreen()
            AddArticleSheetView()
                .presentationDetents([.fraction(0.8)])
                .presentationCornerRadius(30)

        }
            
        
    }
}

#Preview {
    HeaderHomeSectionView()
}
