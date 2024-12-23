import SwiftUI

struct AddAdviceSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var adviceViewModel: AdviceViewModel // تمرير ViewModel للطبيب
    
    var body: some View {
        VStack {
            // العنوان الرئيسي
            Text(adviceViewModel.editingAdvice == nil ? "إنشاء النصيحة اليومية" : "تعديل النصيحة")
                .font(.title)
                .padding(.vertical)
            
            // القسم العلوي
            HStack {
                Image(systemName: "text.book.closed")
                Text("الموضوع")
                
                Spacer()

            }
            .padding(.horizontal, 20)
            .foregroundStyle(.secondary)
            
            // إدخال النص
            TextEditor(text: $adviceViewModel.newAdviceText)
                .frame(height: 150)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(25)
            
            // زر النشر
            Button {
                if adviceViewModel.newAdviceText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    // عرض رسالة خطأ إذا كان النص فارغًا
                    print("النصيحة لا يمكن أن تكون فارغة")
                    return
                }
                adviceViewModel.addAdvice()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("نشر")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .padding(.horizontal, 10)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .padding(.top)
            }
            
//            Spacer()
        }
        .padding()
    }
}


#Preview {
    AddAdviceSheetView(adviceViewModel: AdviceViewModel(author: DoctorModel(user: UserModel(fullName: "", email: "", userType: .doctor), specialization: "", licenseNumber: "")))

}
