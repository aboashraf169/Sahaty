//
//  FotterArtical.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//

import SwiftUI

struct FottarArtical: View {
    @State private var stateLike = false
    @State private var stateSave = false
    @State private var showCommentView = false
    @State private var showShereSheet = false

    @State var comments: [CommentModel] // قائمة التعليقات القابلة للتعديل

    
    var commentCount: Int {
        comments.count
    }

    var body: some View {
        VStack {
            HStack(spacing: 20) {
                
                // زر الإعجاب
                Button {
                    if commentCount != 0 {
                        if stateLike{
                        }else {
                        }
                    }
                    
                } label: {
                    HStack {
                        Image(systemName: stateLike ? "heart.fill" : "heart")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(stateLike ? .accent : .primary)
                        Text("\(commentCount)")
                            .font(.callout)
                            .fontWeight(.ultraLight)
                    }
                }
                .foregroundStyle(.primary)

                
                // زر عرض التعليقات
                Button {
                    showCommentView.toggle()
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "message")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundStyle(.primary)
                        Text("\(commentCount)") // عرض عدد التعليقات
                            .font(.callout)
                            .fontWeight(.ultraLight)
                    }
                }
                .foregroundStyle(.primary)

                
                Spacer()
                // زر المشاركة
                Button {
                    showShereSheet.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                }
                .foregroundStyle(.primary)
                // زر الحفظ
                Button {
                    stateSave.toggle()
                } label: {
                    Image(systemName: stateSave ? "bookmark.fill" : "bookmark")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                        .foregroundStyle(stateSave ? .accent : .primary)
                }
     
                
            }
            
            .padding(.horizontal)
            .actionSheet(isPresented: $showShereSheet) {
                getActionSheet()
            }
            .sheet(isPresented: $showCommentView) {
                AddCommentView(
                    currentUser: .doctor(DoctorModel(
                    user: UserModel(fullName: "د. محمد", email: "doctor@example.com", profilePicture: nil, age: 40, gender: .male, userType: .doctor),
                        specialization: "طب",
                        licenseNumber: "12345",
                        biography: nil
                  )))
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.fraction(0.7)])
            }

            Divider()
                .padding(.top, 5)
        }
    }
    private func getActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("ماذا تريد أن تفعل؟"),
            buttons: [
                .default(Text("مشاركة")) {},
                .cancel(Text("إلغاء"))
            ]
        )
    }
}


#Preview {
    FottarArtical(comments: [])
}
       
