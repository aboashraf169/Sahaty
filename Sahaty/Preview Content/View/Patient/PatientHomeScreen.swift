import SwiftUI

struct PatientHomeScreen: View {
    @EnvironmentObject var appState: AppState // استقبال حالة التطبيق
    @StateObject private var adviceViewModel: AdviceViewModel
    @StateObject private var articlesViewModel: ArticalsViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    @State private var searchText = ""

        init() {
            let patient = PatiantModel.defaultData
            let adviceViewModel = AdviceViewModel(currentUser: .patient(patient))
            _adviceViewModel = StateObject(wrappedValue: adviceViewModel)
            _articlesViewModel = StateObject(wrappedValue: ArticalsViewModel(currentUser: .patient(patient)))
        }

    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header Section
                HeaderHomeSectionView(
                    userType: .patient,
                    searchText: $searchText, // تمرير نص البحث كـ Binding
                    onProfileTap: {
                        appState.selectedTabPatients = .settings
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
                        titleCategory(title: "daily_advices".localized())
                        dailyAdviceSection
                                    
                    // MARK: - Categories Section
                        titleCategory(title: "categories".localized())
                        categoriesSection
                    // MARK: - Articles Section
                    titleCategory(title: "new_articles".localized())
                        if articlesViewModel.Articals.isEmpty {
                                VStack(spacing: 20) {
                                    
                                    Image("noArtical")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 150)
                                        .foregroundColor(.gray.opacity(0.7))
                                    //                     title: "no_articles",
                                    //                    description: "add_new_article",
                                    Text("no_articles".localized())
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 30)
                                    
                                }
                        } else {
                            VStack(spacing: 10) { // يمكنك إضافة تباعد بين المقالات هنا
                                ForEach(articlesViewModel.Articals) { article in
                                    ArticleView(articlesModel: ArticalModel(description: article.description, name: article.name, userName: article.userName, addTime: article.addTime, imagePost: article.imagePost, personImage: article.imagePost), articlesViewModel: articlesViewModel,userType: .patient)
                                }
                            }
                        }
                    
                    
                }
            }

        }
        .direction(appLanguage) // اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة
    }
    
    // MARK: - Daily Advice Section
    private var dailyAdviceSection: some View {
        Group {
            if let advice = adviceViewModel.advices.first {
                Button {
                    print("عرض تفاصيل النصيحة: \(advice.content)")
                } label: {
                    
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .foregroundStyle(Color.accentColor)
                        .overlay(
                            HStack {
                                Image("idea")

                                ViewThatFits {
                                    Text("\"\(advice.content)\"")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            }
                            .padding()
                        )
                }
                .buttonStyle(.plain)
            } else {
                HStack {
                    Text("no_advices".localized())
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.horizontal,20)
            }
        }
    }

    
    // MARK: - Categories Section
    private var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Categoryy(title: "mental_health".localized(), imageName: "face.smiling")
                Categoryy(title: "chronic_diseases".localized(), imageName: "arrow.clockwise.heart")
                Categoryy(title: "healthy_nutrition".localized(), imageName: "fork.knife.circle")
            }
            .padding(.horizontal)
        }
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
    PatientHomeScreen()
}
