import SwiftUI

struct DoctorHomeScreen: View {
    
    @EnvironmentObject var appState: AppState // استقبال حالة التطبيق
    
    var currentUser: CommentAuthor?
    
    @StateObject var adviceViewModel: AdviceViewModel
    @StateObject var articlesViewModel: ArticalsViewModel
    @State private var showAddAdviceView: Bool = false
    @State private var showAddArticleView: Bool = false
    @State private var selectedArticle: ArticalModel? = nil
    @State private var showEditArticleSheet = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    
    init(doctor: DoctorModel) {
        let adviceViewModel = AdviceViewModel(author: doctor)
        let articlesViewModel = ArticalsViewModel(currentUser: .doctor(doctor))
        _adviceViewModel = StateObject(wrappedValue: adviceViewModel)
        _articlesViewModel = StateObject(wrappedValue: articlesViewModel)
    }
    
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
    }
    
    // MARK: - Advice Section
    private var adviceSection: some View {
        VStack {
            HStack {
                if !$adviceViewModel.advices.isEmpty {
                    Button {
                        showAddAdviceView.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.primary)
                    }
                }
                Text("daily_advices")
                    .font(.headline)
                    .fontWeight(.regular)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            .sheet(isPresented: $showAddAdviceView) {
                AddAdviceSheetView(adviceViewModel: adviceViewModel)
                    .presentationDetents([.fraction(0.45)])
                    .presentationCornerRadius(30)
            }
            
            if adviceViewModel.advices.isEmpty {
                HStack {
                    Text("no_advices".localized())
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.horizontal,20)
            } else {
                List {
                    ForEach(adviceViewModel.advices) { advice in
                        AdviceView(advice: advice)
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                swipeActions(for: advice)
                            }
                    }
                }
                .listStyle(.plain)
                .frame(height: 130)
            }
        }
    }
    
    // MARK: - Swipe Actions for Advice
    func swipeActions(for advice: AdviceModel) -> some View {
        Group {
            Button {
                adviceViewModel.startEditing(advice: advice)
                showAddAdviceView.toggle()
            } label: {
                Label("edit", systemImage: "pencil")
            }
            .tint(.accent)
            
            Button {
                if let index = adviceViewModel.advices.firstIndex(where: { $0.id == advice.id }) {
                    adviceViewModel.deleteAdvice(at: IndexSet(integer: index))
                }
            } label: {
                Label("delete", systemImage: "trash")
            }
            .tint(.red)
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
    let doctor = DoctorModel(
        fullName: "د. محمد أشرف",
        email: "doctor@example.com",
        specialization: "طب الأطفال",
        licenseNumber: "12345",
        profilePicture: "post",
        biography: nil,
        articlesCount: 10,
        advicesCount: 20,
        followersCount: 50,
        articles: [],
        advices: [],
        comments: [],
        likedArticles: []
    )

    DoctorHomeScreen(doctor: doctor)
}
