import SwiftUI

struct HeaderHomeSectionView: View {
    @ObservedObject var doctorProfileViewModel: DoctorProfileViewModel
    @Binding var searchText: String // نص البحث
    var onProfileTap: () -> Void // الإجراء عند النقر على صورة المستخدم
    var onAddTap: (() -> Void)? = nil // الإجراء عند النقر على زر الإضافة (للدكتور فقط)

    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    
    var body: some View {
        VStack{
        HStack(spacing: 16) {
            // صورة المستخدم (بتأثيرات أجمل عند الضغط)
            Button(action: onProfileTap) {
                profileImage
                    .overlay(
                        Circle()
                            .stroke(Color.accentColor.opacity(0.5), lineWidth: 2) // إضافة حد ناعم أزرق
                    )
                    .shadow(color: .accentColor.opacity(0.2), radius: 3) // إضافة ظل خفيف للصورة
            }
            .buttonStyle(ScaleButtonStyle()) // تأثير أنيق عند الضغط
            
            // اسم الدكتور
            Text(doctorProfileViewModel.doctor.name)
                .foregroundStyle(.primary)
                .font(.headline)
                .fontWeight(.medium)
            
            
            Spacer()
            
            // زر إضافة المقال (للدكتور فقط)
            if let onAddTap = onAddTap {
                Button(action: onAddTap) {
                    addButton
                }
                .buttonStyle(ScaleButtonStyle()) // تأثير عند الضغط
            }
            
        }
        .padding(.horizontal)
//        .padding(.vertical, 12)
            Divider()
    }
//        .background(
//            RoundedRectangle(cornerRadius: 15)
//                .fill(Color(.systemGray6))
//                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
//        )
        .direction(appLanguage) // ضبط الاتجاه
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة
        .onAppear {
            doctorProfileViewModel.loadImage(from: doctorProfileViewModel.doctor.img ?? "")
        }
    }
}

// ✅ **إضافة التأثيرات والأزرار بشكل مستقل**
private extension HeaderHomeSectionView {
    // 🔹 **صورة الملف الشخصي**
    var profileImage: some View {
        Group {
            if let img = doctorProfileViewModel.doctorProfileImage {
                Image(uiImage: img)
                    .resizable()
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.7))
            }
        }
        .scaledToFill()
        .frame(width: 40, height: 40)
        .background(Color.white)
        .clipShape(Circle())
        .shadow(radius: 3)
    }

    // 🔹 **زر إضافة المقال بتصميم حديث**
    var addButton: some View {
        HStack {
            Image(systemName: "text.badge.plus")
                .font(.title3)
                .foregroundStyle(.accent)
            Text("new_article".localized())
                .fontWeight(.bold)
                .foregroundStyle(.primary)

        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

// 🔹 **إضافة تأثير أنيق عند الضغط على الأزرار**
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

// MARK: - Preview
#Preview {
    HeaderHomeSectionView(
        doctorProfileViewModel: DoctorProfileViewModel(),
        searchText: .constant(""),
        onProfileTap: {
            print("Profile tapped")
        },
        onAddTap: {
            print("Add button tapped")
        }
//        onSearch: { searchText in
//            print("Searching for: \(searchText)")
//        }
    )
}



//            // صندوق البحث
//            TextField("search_placeholder".localized(), text: $searchText, onEditingChanged: { _ in
//                // عند بدء أو إنهاء التعديل
//            }, onCommit: {
//                // عند الضغط على زر الإدخال
//                onSearch(searchText)
//            })
//                .font(.callout)
//                .foregroundStyle(.secondary)
//                .padding(10)
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//                .overlay(
//                    HStack {
//                        Spacer()
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(.secondary)
//                            .padding(.trailing, 10)
//                    }
//                )
