//
//  AdviceView.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//

import  SwiftUI
struct AdviceView: View {
    var advice: AdviceModel // النصيحة التي سيتم عرضها

    var body: some View {
        HStack{
            // شريط جانبي ملون
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5, height: 25)
                .foregroundStyle(.accent)

            
            // محتوى النصيحة
            Text(advice.content)
                .font(.caption)
                .lineLimit(4)
                .opacity(0.5)
            Spacer()
        }
    }
}
#Preview {
    AdviceView(advice: AdviceModel(content: "", authorId: UUID(), publishDate: .now))
}
