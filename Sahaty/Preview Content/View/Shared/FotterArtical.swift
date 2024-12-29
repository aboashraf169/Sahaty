//
//  FotterPost.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//

import SwiftUI

struct FotterArtical: View {
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
                AddCommentView(currentUser: .doctor(DoctorModel(
                    id: UUID(),
                    fullName: "الحارث نبيل",
                    email: "ahmed@example.com",
                    specialization: "Cardiology",
                    licenseNumber: "12345",
                    profilePicture: "doctor",
                    biography: "طبيب مختص في أمراض القلب.",
                    articlesCount: 25,
                    advicesCount: 10,
                    followersCount: 500,
                    articles: [],
                    advices: [],
                    comments: [],
                    likedArticles: []
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
    FotterArtical(comments: [
        CommentModel(
            text: "تعليق ممتاز جدًا!",
            author: .doctor(DoctorModel(
                id: UUID(),
                fullName: "د. أحمد خالد",
                email: "ahmed@example.com",
                specialization: "القلب والأوعية",
                licenseNumber: "123456",
                profilePicture: "doctor",
                biography: "خبرة 15 سنة في أمراض القلب.",
                articlesCount: 10,
                advicesCount: 5,
                followersCount: 200,
                articles: [],
                advices: [],
                comments: [],
                likedArticles: []
            )),
            publishDate: Date(),
            likeCount: 10,
            CommentCount: 5
        )
    ])
}
