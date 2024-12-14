//
//  CommentVirew.swift
//  Sahaty
//
//  Created by mido mj on 12/14/24.
//

import SwiftUI

    struct CommentView: View {
        let comment: CommentModel

        var body: some View {
            HStack(alignment: .top, spacing: 10) {
                Spacer() // لإجبار المحتوى على الالتفاف باتجاه اليمين
                
                // Comment Content
                VStack(alignment: .trailing, spacing: 5) { // ضبط المحاذاة على اليمين
                    Text(comment.username)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.trailing) // محاذاة الاسم على اليمين
                    
                    Text(comment.text)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing) // محاذاة النص على اليمين
                }
                
                // User Avatar
                Image(comment.image ?? "post")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
            }
            .padding(.vertical, 5)
        }
    }



struct CommentScreen: View {
    @StateObject private var viewModel = CommentViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                // Comments List
                List {
                    ForEach(viewModel.comments) { comment in
                        CommentView(comment: comment)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                swipeActions(for: comment)
                            }
                    }
                }
                .listStyle(.plain)
                
                Divider()
                
                // Add or Edit Comment Section
                HStack {
                        Button(action: viewModel.addComment) {
                                    Image(systemName: "paperplane.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.accentColor)
                                        .background(
                                            Rectangle()
                                                .frame(width: 50, height: 50)
                                                .foregroundStyle(Color(.systemGray6))
                                                .cornerRadius(10)
                                        )
                                        .padding(.horizontal)
                                
                        }
                        Spacer()
                        TextField("أضف تعليقًا...", text: $viewModel.newComment)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .padding(.horizontal)
                            .cornerRadius(10)

                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical,10)
                .padding(.horizontal)


            }
            .navigationTitle("التعليقات")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.layoutDirection, .leftToRight) // RTL for Arabic
        }
    }
    
    private func swipeActions(for comment: CommentModel) -> some View {
        Group {
            // Edit Action
            Button {
                viewModel.startEditing(comment: comment)
            } label: {
                Label("تعديل", systemImage: "pencil")
            }
            .tint(.blue)
            
            // Delete Action
            Button(role: .destructive) {
                if let index = viewModel.comments.firstIndex(where: { $0.id == comment.id }) {
                    viewModel.deleteComment(at: IndexSet(integer: index))
                }
            } label: {
                Label("حذف", systemImage: "trash")
            }
        }
    }
}


#Preview {
    CommentScreen()
}
