import SwiftUI

struct HeaderHomeSectionView: View {
    var userType: UserType // نوع المستخدم
    @Binding var searchText: String // نص البحث
    var onProfileTap: () -> Void // الإجراء عند النقر على صورة المستخدم
    var onAddTap: (() -> Void)? = nil // الإجراء عند النقر على زر الإضافة (للدكتور فقط)
    var onSearch: (String) -> Void // الإجراء عند تحديث نص البحث
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        HStack {
            // صورة المستخدم
            Button {
                onProfileTap()
            } label: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 2)
                    .padding(.top, 5)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
        
            }

            // صندوق البحث
            TextField("search_placeholder".localized(), text: $searchText, onEditingChanged: { _ in
                // عند بدء أو إنهاء التعديل
            }, onCommit: {
                // عند الضغط على زر الإدخال
                onSearch(searchText)
            })
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                            .padding(.trailing, 10)
                    }
                )

            // زر إضافة المقال (للدكتور فقط)
            if userType == .doctor, let onAddTap = onAddTap {
                Button {
                    onAddTap()
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 50)
                        .frame(height: 40)
                        .foregroundStyle(Color(.systemGray6))
                        .overlay {
                            Image(systemName: "text.badge.plus")
                                .scaledToFit()
                                .foregroundStyle(.primary)
                        }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .direction(appLanguage) // ضبط الاتجاه
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة
    }
}

// MARK: - Preview
#Preview {
    HeaderHomeSectionView(
        userType: .doctor,
        searchText: .constant(""),
        onProfileTap: {
            print("Profile tapped")
        },
        onAddTap: {
            print("Add button tapped")
        },
        onSearch: { searchText in
            print("Searching for: \(searchText)")
        }
    )
}
