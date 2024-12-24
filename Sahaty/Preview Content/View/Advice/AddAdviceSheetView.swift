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
    // إنشاء نموذج طبيب تجريبي
    let doctor = DoctorModel(
        fullName: "د. محمد أشرف",
        email: "doctor@example.com",
        specialization: "طب الأطفال",
        licenseNumber: "12345",
        profilePicture: nil,
        biography: nil,
        articlesCount: 10,
        advicesCount: 20,
        followersCount: 50,
        articles: [],
        advices: [],
        comments: [],
        likedArticles: []
    )
    AddAdviceSheetView(adviceViewModel:  AdviceViewModel(author: doctor))

}
