import SwiftUI

struct DoctorHomeScreen: View {
    
    @EnvironmentObject var appState: AppState // استقبال حالة التطبيق
    
    var currentUser:String =  ""
    
    @StateObject var adviceViewModel: AdviceViewModel
    @StateObject var articlesViewModel: ArticalsViewModel
    @State private var showAddAdviceView: Bool = false
    @State private var showAddArticleView: Bool = false
    @State private var selectedArticle: ArticleModel? = nil
    @State private var showEditArticleSheet = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header Section
                HeaderHomeSectionView(
                    usersType: .doctor,
                    searchText: .constant(""), // تمرير نص البحث كـ Binding
                    onProfileTap: {
                        appState.selectedTabDoctors = .profile
                        print("تم النقر على صورة المستخدم (الدكتور)")
                    },
                    onAddTap: {
                        showAddArticleView.toggle()
                    }, onSearch: { text in
                        print("تم النقر على البحث المستخدم (الدكتور)")
                    }
                )
                
                // MARK: - Advice Section
                adviceSection
                
                // MARK: - Articles Section
                articlesSection
                
                Spacer()
            }
        }
        .direction(appLanguage) // اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة
        .onAppear{
            adviceViewModel.loadAdvicesFromCoreData()
        }
        
    }
    
    // MARK: - Advice Section
    private var adviceSection: some View {
        VStack(alignment: .leading) {
            // العنوان وزر الإضافة
            HStack {
                Text("daily_advices".localized())
                    .font(.headline)
                    .fontWeight(.regular)
                
                Spacer()
                
                Button {
                    showAddAdviceView.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.accent)
                }
                .sheet(isPresented: $showAddAdviceView) {
                    AddAdviceSheetView(adviceViewModel: adviceViewModel)
                        .presentationDetents([.fraction(0.45)]) // نسبة العرض
                        .presentationCornerRadius(30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // عرض النصائح
            if adviceViewModel.advices.isEmpty {
                // في حال عدم وجود نصائح
                HStack {
                    Text("no_advices".localized())
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.horizontal, 20)
            } else {
                // في حال وجود نصائح
                List {
                    ForEach(adviceViewModel.advices) { advice in
                        AdviceView(
                            advice: advice,
                            onEdit: { selectedAdvice in
                                adviceViewModel.startEditing(advice: selectedAdvice) // بدء تعديل النصيحة
                                showAddAdviceView.toggle()
                            },
                            onDelete: { selectedAdvice in
                                adviceViewModel.deleteAdvice(id: selectedAdvice.id) { success in
                                    if success {
                                        print("Advice deleted.")
                                    }
                                }
                            }
                        )
                    }
                }
                .listStyle(.plain)
                .frame(maxHeight: 200) // ضبط أقصى ارتفاع للقائمة
            }
        }
    }

    // MARK: - Articles Section
    private var articlesSection: some View {
        VStack {
            HStack {
                Text("new_articles")
                    .font(.headline)
                    .fontWeight(.regular)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .sheet(isPresented: $showAddArticleView) {
                AddArticleSheetView(articalsViewModel: articlesViewModel)
                    .presentationDetents([.fraction(0.8)])
                    .presentationCornerRadius(30)
            }
            
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
            }else {
                ScrollView {
                    LazyVStack {
                        ForEach(articlesViewModel.Articals) { article in
                            ArticleView(
                                articlesModel: article,
                                articlesViewModel: articlesViewModel,
                                usersType: .doctor
                            )
                        }
                    }
                }
            }
        }
    }
    
    
}
#Preview {

}
