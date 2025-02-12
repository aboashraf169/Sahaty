import SwiftUI

struct PatientHomeScreen: View {
    @ObservedObject  var adviceViewModel: AdviceViewModel
    @ObservedObject  var articlesViewModel: ArticalsViewModel
    @ObservedObject var patientViewModel : PatientSettingViewModel
    @StateObject var specializationViewModel  = SpecializationViewModel()
    @EnvironmentObject var appState: AppState
    @AppStorage("appLanguage") private var appLanguage = "ar"
    @State private var searchText = ""
    @State private var showAllSpecializations = false

    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header Section
                HeaderPatientHomeSectionView(
                    patientViewModel : patientViewModel,
                    searchText: $searchText, // تمرير نص البحث كـ Binding
                    onProfileTap: {
                        appState.selectedTabPatients = .settings
                        print("تم النقر على صورة المستخدم (الدكتور)")
                    },
                    onAddTap: {
                    }, onSearch: {_ in 
                    }
                )
                ScrollView {
                    // MARK: - Daily Advice Section
                        titleCategory(title: "daily_advices".localized())
                        dailyAdviceSection
                                    
                    // MARK: - Categories Section
                    HStack {
                        Text("categories".localized())
                            .font(.headline)
                            .fontWeight(.regular)
                        Spacer()
                        Button {
                            showAllSpecializations.toggle()
                        } label: {
                            Text("Show All".localized())
                                .font(.headline)
                                .fontWeight(.regular)
                                .foregroundStyle(Color.accent)
                        }

                       
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.vertical,10)
                    .cornerRadius(10)
                    .padding(.horizontal,10)
                    .sheet(isPresented: $showAllSpecializations) {
                        AllSpecializationsView(specializationViewModel: specializationViewModel)
                    }
                    
                    categoriesSection
                
                    // MARK: - Articles Section
                    titleCategory(title: "new_articles".localized())
                        if articlesViewModel.articals.isEmpty {
                                VStack(spacing: 20) {
                                    Image("noArtical")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 150)
                                        .foregroundColor(.gray.opacity(0.7))

                                    Text("no_articles".localized())
                                        .font(.title2)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 30)
                                    
                                }
                        } else {
                            VStack(spacing: 10) {
                                ForEach(articlesViewModel.articals) { article in
                                    ArticleView(articleModel: article, articalViewModel: articlesViewModel, usersType: .patient,path: article.img ?? "")
                                }
                            }
                        }
                    
                }
            }

        }
        .direction(appLanguage)
        .environment(\.locale, .init(identifier: appLanguage))
        .preferredColorScheme(patientViewModel.isDarkModePatient ? .dark : .light)
        .onAppear{
            articlesViewModel.fetchArtical(isDoctor: false)
            specializationViewModel.getSpacialties()
            adviceViewModel.getUserAdvice()
        }
    }
    
    // MARK: - Daily Advice Section
    private var dailyAdviceSection: some View {
        Group {
            if let advice = adviceViewModel.userAdvices.last {
                Button {
                    print("عرض تفاصيل النصيحة: \(advice.advice) - \( advice.id)")
                } label: {
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .foregroundStyle(Color.accentColor)
                        .overlay(
                            HStack {
                                Image("idea")
                                ViewThatFits {
                                    Text((advice.advice))
                                        .font(.callout)
                                        .foregroundColor(.white)
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                Spacer()
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
                ForEach(specializationViewModel.specializations){ specialist in
                    CategorySpecializaton(specialization: specialist){action in
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxHeight: 100)
       
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



// MARK: - All AllSpecializations
struct AllSpecializationsView : View {
    @ObservedObject var specializationViewModel  : SpecializationViewModel
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    var body : some View {
        NavigationStack{
            List{
                ForEach(specializationViewModel.specializations){ specialist in
                    Button{
                        
                    }label: {
                        HStack {
                            Text(".\(specialist.id)")
                                .font(.footnote)
                            Text(specialist.name)
                            Spacer()
                            Image(systemName: "square")
                                .foregroundColor(.accent)
                                .font(.title2)

                        }
                        .padding()
                        .frame(height: 50)
                        
                        }
                    .tint(.primary)
                    
                }
            }
            .listStyle(PlainListStyle())
            Spacer()
            .navigationTitle("all_specialty".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
        .direction(appLanguage) // اتجاه النصوص
        .environment(\.locale, .init(identifier: appLanguage))
    }

}

    // MARK: - Category Specializaton
struct CategorySpecializaton: View {
    var specialization  : spectialties
    var action : (Bool) -> Void
    var body: some View {
        Button{
        }label: {
            HStack {
                Text(specialization.name)
                Spacer()
                Image(systemName: "square")
                    .foregroundColor(.accent)
                    .font(.title2)
            }
            .padding()
            .frame(width: 220, height: 50)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            }
        .tint(.primary)
        }
    }



// MARK: - Preview
#Preview {
    PatientHomeScreen(adviceViewModel: AdviceViewModel(), articlesViewModel: ArticalsViewModel(), patientViewModel: PatientSettingViewModel())
}
