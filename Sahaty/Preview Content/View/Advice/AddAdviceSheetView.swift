import SwiftUI

struct AddAdviceSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var adviceViewModel: AdviceViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar"

    var body: some View {
        VStack {
            // العنوان
            Text(adviceViewModel.editingAdvice == nil ? "create_daily_advice".localized() : "edit_advice".localized())
                .font(.title)
                .padding(.vertical)

            // إدخال النص
            TextEditor(text: $adviceViewModel.newAdviceText)
                .frame(height: 150)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)

            // زر الحفظ
            Button {
                adviceViewModel.addOrUpdateAdvice()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text(adviceViewModel.editingAdvice == nil ? "publish".localized() : "save_changes".localized())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .padding(.top)
            }
        }
        .padding()
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
    }
}

#Preview {
//    AddAdviceSheetView(adviceViewModel:  AdviceViewModel(author: doctor))

}
