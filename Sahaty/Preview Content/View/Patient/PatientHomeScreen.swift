import SwiftUI

struct PatientHomeScreen: View {
    @StateObject private var adviceViewModel: AdviceViewModel
    @StateObject private var articlesViewModel: ArticalsViewModel
    @State private var searchText = ""

        init(patient: PatientModel) {
            _adviceViewModel = StateObject(wrappedValue: adviceViewModel)
            _articlesViewModel = StateObject(wrappedValue: ArticalsViewModel(currentUser: .patient(patient)))
        }

    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header Section
//                HeaderHomeSectionView(userType: .doctor)
                HeaderHomeSectionView(
                    userType: .patient,
                    searchText: $searchText, // تمرير نص البحث كـ Binding
                    onProfileTap: {
                        print("تم النقر على صورة المستخدم (الدكتور)")
                    },
                    onAddTap: {
                        print("تم النقر على زر الإضافة")
                    }, onSearch: { query in
                            adviceViewModel.searchText = query
//                            articlesViewModel.searchText = query
//                        
                    }
                )
                ScrollView {
                    // MARK: - Daily Advice Section
                    titleCategory(title: "نصائح اليوم")
                    dailyAdviceSection
                    
                    // MARK: - Categories Section
                    titleCategory(title: "التخصصات")
                    categoriesSection
                    
                    // MARK: - Articles Section
                        titleCategory(title: "المقالات الجديدة")
                        if articlesViewModel.Articals.isEmpty {
                            noDataView(
                                imageName: "tray",
                                title: "لا توجد منشورات حاليًا",
                                description: "ابدأ بمتابعة المقالات الجديدة المفيدة."
                            )
                        } else {
                            VStack(spacing: 10) { // يمكنك إضافة تباعد بين المقالات هنا
                                ForEach(articlesViewModel.Articals) { article in
                                    ArticleView(
                                              articlesModel: article,
                                              articlesViewModel: articlesViewModel,
                                              userType: .patient
                                          )
                                }
                            }
                        }
                    
                    
                }
            }
        }
    }
    
    // MARK: - Daily Advice Section
    private var dailyAdviceSection: some View {
        Group {
            if let advice = adviceViewModel.advices.first {
                Button {
                    print("عرض تفاصيل النصيحة: \(advice.content)")
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .overlay(
                            HStack {
                                Image(systemName: "lightbulb")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                
                                Text("\"\(advice.content)\"")
                                    .font(.callout)
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                            .padding()
                        )
                }
                .buttonStyle(.plain)
            } else {
                noDataView(
                    imageName: "lightbulb.slash.fill",
                    title: "لا توجد نصائح حتى الآن!",
                    description: "ابدأ بمتابعة النصائح اليومية لتحسين صحتك."
                )
            }
        }
    }


    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Categoryy(title: "الصحة النفسية", imageName: "face.smiling")
                Categoryy(title: "الأمراض المزمنة", imageName: "arrow.clockwise.heart")
                Categoryy(title: "التغذية الصحية", imageName: "fork.knife.circle")
            }
            .padding(.horizontal)
        }
    }
    


    
    // MARK: - No Data View
    private func noDataView(imageName: String, title: String, description: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray.opacity(0.7))
            
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.top)
    }
    
    // MARK: - Title Category
    private func titleCategory(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.regular)
            Spacer()
        }
        .multilineTextAlignment(.leading)
        .padding(.vertical, 10)
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }
}

struct Categoryy: View {
    var title: String
    var imageName: String
    
    var body: some View {
        Button {
            // Add category selection action
        } label: {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity)
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
                    .fontWeight(.light)
            }
            .opacity(0.8)
            .padding()
            .frame(width: 170, height: 50)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .foregroundStyle(.primary)

    }
}

// MARK: - Preview
#Preview {
    PatientHomeScreen(patient: PatientModel(user: UserModel(fullName: "", email: "", userType: .patient)))
}
