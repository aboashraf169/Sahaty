import SwiftUI

struct AddAdviceSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var adviceViewModel: AdviceViewModel // تمرير ViewModel للطبيب
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        VStack {
            // العنوان الرئيسي
            Text(adviceViewModel.editingAdvice == nil ? "create_daily_advice".localized() : "edit_advice".localized())
                .font(.title)
                .padding(.vertical)
            
            // القسم العلوي
            HStack {
                Image(systemName: "text.book.closed")
                      Text("topic".localized())
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
                Text("publish".localized())
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
        .direction(appLanguage) // اتجاه النصوص بناءً على اللغة
        .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة
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
