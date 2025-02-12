//
//  CommentView.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//
import SwiftUI

struct CommentView: View {
    
    let comment: CommentModel
    var body: some View {
        HStack(alignment: .top, spacing: 10) {

            // الصورة الرمزية
            if let image = comment.user.img {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(.top,10)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.accent)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.accentColor, lineWidth: 3))
            }
            

            // المحتوى
            VStack(alignment: .leading, spacing: 5) {
                Text("\(comment.user.name)")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Text(comment.comment)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

  
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    CommentView(comment: CommentModel())
}
