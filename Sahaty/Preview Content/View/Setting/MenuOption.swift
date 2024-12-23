//
//  MenuOption.swift
//  Sahaty
//
//  Created by mido mj on 12/24/24.
//
import SwiftUI

struct MenuOption : View {
    
    let id = UUID()
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
                HStack {
                    
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                        .background(Color.accentColor.opacity(0.2)).cornerRadius(10)

                    Text(title)
                        .font(.body)
                        .foregroundColor(.gray)

                    Spacer()

                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
        }
        
    }

}
