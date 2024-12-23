import SwiftUI

struct DoctorHomeScreen: View {
    
    @EnvironmentObject var appState: AppState // استقبال حالة التطبيق

    var currentUser: CommentAuthor?

    @StateObject  var adviceViewModel: AdviceViewModel
    @StateObject  var articlesViewModel: ArticalsViewModel
    @State private var showAddAdviceView: Bool = false
    @State private var showAddArticleView: Bool = false
    @State private var selectedArticle: ArticalModel? = nil
    @State private var showEditArticleSheet = false
    
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
//                HeaderHomeSectionView(userType: .doctor)
                HeaderHomeSectionView(
                    userType: .doctor,
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
                Text("نصائح اليوم")
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
                noDataView(
                    imageName: "lightbulb.slash.fill",
                    title: "لا توجد نصائح حتى الآن!",
                    description: "ابدأ بإضافة نصيحة جديدة لتحفيز الآخرين.",
                    action: { showAddAdviceView.toggle() }
                )
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(adviceViewModel.advices) { advice in
                            AdviceView(advice: advice)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    swipeActions(for: advice)
                                }
                        }
                    }
                }
                .listStyle(.plain)
                .frame(maxHeight: 200)
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
                Label("تعديل", systemImage: "pencil")
            }
            .tint(.accent)

            Button {
                if let index = adviceViewModel.advices.firstIndex(where: { $0.id == advice.id }) {
                    adviceViewModel.deleteAdvice(at: IndexSet(integer: index))
                }
            } label: {
                Label("حذف", systemImage: "trash")
            }
            .tint(.red)
        }
    }
    

    // MARK: - Articles Section
    private var articlesSection: some View {
        VStack {
            HStack {
                if !articlesViewModel.Articals.isEmpty {
                    Button {
                        showAddArticleView.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.primary)
                    }
                }
                Text("مقالات جديدة")
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
                noDataView(
                    imageName: "tray",
                    title: "لا توجد مقالات حاليًا",
                    description: "ابدأ بإضافة مقالة جديدة لمساعدة الآخرين.",
                    action: { showAddArticleView.toggle() }
                )
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(articlesViewModel.Articals) { article in
                            ArticleView(
                                articlesModel: article,  // استخدام المقالة الأصلية مباشرة
                                articlesViewModel: articlesViewModel,
                                userType: .doctor
                            )
                            
                        }
                    }
                }
            }
        }
    }


    // MARK: - No Data View
    private func noDataView(imageName: String, title: String, description: String, action: @escaping () -> Void) -> some View {
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

            Button(action: action) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.accentColor)
            }
            .padding(.bottom, 20)
        }
        .padding(.top)
    }
}

#Preview {
    DoctorRowView(doctor: DoctorModel(user: UserModel(fullName: "", email: "", userType: .doctor), specialization: "", licenseNumber: ""))
}
