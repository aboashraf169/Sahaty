//
//  AdviceView.swift
//  Sahaty
//
//  Created by mido mj on 12/17/24.
//

import  SwiftUI
struct AdviceView: View {
    var advice: AdviceModel // النصيحة التي سيتم عرضها
    var onEdit: (AdviceModel) -> Void // إجراء التعديل
    var onDelete: (AdviceModel) -> Void // إجراء الحذف

    var body: some View {
        HStack {
            // شريط جانبي ملون
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 5, height: 40)
                .foregroundStyle(.accent)

            VStack(alignment: .leading, spacing: 5) {
                // محتوى النصيحة
                Text(advice.advice)
                    .font(.body)
                    .fontWeight(.semibold)
                    .lineLimit(3)
                    .foregroundColor(.primary)

                // وقت الإنشاء أو التحديث
                Text("Last updated: \(advice.updatedAt)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // أزرار التعديل والحذف
            HStack(spacing: 10) {
                Button {
                    onEdit(advice) // استدعاء إجراء التعديل
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }

                Button {
                    onDelete(advice) // استدعاء إجراء الحذف
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 1, x: 0, y: 1)
    }
}


#Preview {
//    AdviceView(advice: AdviceModel(id: 0, advice: "", doctorID: 1, createdAt: "", updatedAt: ""))
}
