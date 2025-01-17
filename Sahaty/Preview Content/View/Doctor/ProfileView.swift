import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel = DoctorProfileViewModel() // إنشاء viewModel مرة واحدة
    @ObservedObject var adviceViewModel = AdviceViewModel()
    @State private var isEditingBio = false
    @State private var editedBio: String = ""
    @State private var showImagePicker = false
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showAllAdvices = false
    @State private var showAllArticles = false
    @State private var showAddAdviceView: Bool = false
    @State private var showAddArticleView: Bool = false
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading Profile...".localized())
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Retry".localized()) {
//                        viewModel.fetchDoctorProfile()
                    }
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }else {
            ScrollView {
                VStack {
                    // Header Section
                    ProfileHeaderView(viewModel: viewModel, selectedImage: $selectedImage, showImagePicker: $showImagePicker)
                    
                    // Doctor Statistics
                    DoctorStatisticsView(viewModel: viewModel)
                    
                    // Bio Section
                    BioSectionView(
                        isEditingBio: $isEditingBio,
                        editedBio: $editedBio,
                        biography: viewModel.doctor.bio,
                        onSave: {
                            viewModel.doctor.bio = editedBio
                            isEditingBio = false
                        }
                    )
                    
                    Divider()
                    AdviceSectionView(adviceViewModel: adviceViewModel, showAllAdvices: $showAllAdvices)
                    
                    Divider()
                    ArticlesSectionView(viewModel: viewModel, showAllArticles: $showAllArticles)
                    // Advice Section
                    
                    
                    // Articles Section
                    
                }
                .padding(.horizontal)
            }
            .navigationTitle("الملف الشخصي")
            .navigationBarTitleDisplayMode(.inline)
            .photosPicker(isPresented: $showImagePicker, selection: $selectedImageItem)
            .onChange(of: selectedImageItem) { _, newValue in
                loadImage(newValue)
            }
            // Navigate to All Advices
            .sheet(isPresented: $showAllAdvices) {
                AllAdvicesView(adviceViewModel: AdviceViewModel())
                
                //                AllAdvicesView(advices: viewModel.advices)
            }
            // Navigate to All Articles
            .sheet(isPresented: $showAllArticles) {
//                AllArticlesView(articles: viewModel.articles)
            }
            .direction(appLanguage) // ضبط الاتجاه
            .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة
            .refreshable {
                         adviceViewModel.fetchAdvices() // استدعاء التحديث عند السحب
                     }
        }
    }
    }
    
    
    private func loadImage(_ item: PhotosPickerItem?) {
        if let item = item {
            item.loadTransferable(type: ImageTransferable.self) { result in
                switch result {
                case .success(let image):
                    if let image = image {
                        selectedImage = image.image
                    }
                case .failure(let error):
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - AdviceSectionView
struct AdviceSectionView: View {
    @ObservedObject var adviceViewModel = AdviceViewModel()
    @Binding var showAllAdvices: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Advices".localized())
                    .font(.headline)
                Spacer()
                Button(action: {
                    showAllAdvices.toggle()
                }) {
                    Text("Show All")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
     
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(adviceViewModel.advices) { advice in
                        AdviceView(advice: advice, onEdit: {_ in }, onDelete: {_ in })
                            .frame(width: 230, height: 80)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}

// MARK: - AllArticlesView
struct AllArticlesView: View {
    let articles: [ArticleModel]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(articles) { article in
                        ArticleView(
                            articlesModel: article,
                            articlesViewModel: ArticalsViewModel(),
                            usersType: .doctor
                        )
                    }
                }
            }
            .navigationTitle("all_artical".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - ArticlesSectionView
struct ArticlesSectionView: View {
    @ObservedObject var viewModel: DoctorProfileViewModel
    @Binding var showAllArticles: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Articles".localized())
                    .font(.headline)
                Spacer()
                Button(action: {
                    showAllArticles.toggle()
                }) {
                    Text("Show All".localized())
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
        
            }
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
//                    ForEach(viewModel.articles) { article in
//                        ArticleView(
//                            articlesModel: article,
//                            articlesViewModel: ArticalsViewModel(),
//                            usersType: .doctor
//                        )
//                    }
                }
            }
        }
    }
}

struct AllAdvicesView: View {
    @ObservedObject var adviceViewModel: AdviceViewModel
    @State private var showAddAdviceSheet = false // عرض شاشة الإضافة/التعديل
    @State private var selectedAdvice: AdviceModel? // النصيحة المحددة للتعديل
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    var body: some View {
        NavigationStack {
                    ForEach(adviceViewModel.advices) { advice in
                        AdviceView(advice: advice, onEdit: {_ in }, onDelete: {_ in })
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding()
            Spacer()
                .navigationTitle("all_advice".localized())
                .navigationBarTitleDisplayMode(.inline)

        }
        .direction(appLanguage) // ضبط الاتجاه
        .environment(\.locale, .init(identifier: appLanguage)) // ضبط اللغة
    }
}




// MARK: - ProfileHeaderView
struct ProfileHeaderView: View {
    @ObservedObject var viewModel: DoctorProfileViewModel
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    
    var body: some View {
        VStack() {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
//                else if let image = viewModel.doctor.profilePicture {
//                    Image(image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 120, height: 120)
//                        .clipShape(Circle())
//                        .shadow(radius: 5)
//                }
                else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.accentColor)
                        .shadow(radius: 5)
                    
                }
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "camera.fill")
                        .foregroundStyle(Color.white)
                        .padding(8)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
                .offset(x: -40, y: 40)
                
     
            }
            
            Text(viewModel.doctor.name)
                .font(.headline)
                .fontWeight(.medium)
            
//            Text(viewModel.doctor.specialties)
//                .font(.subheadline)
//                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - DoctorStatisticsView
struct DoctorStatisticsView: View {
    @ObservedObject var viewModel: DoctorProfileViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            StatisticView(title: "Followers".localized(), value: "\(0)")
            StatisticView(title: "Articles".localized(), value: "\(0)")
            StatisticView(title: "Advices".localized(), value: "\(0)")
        }
//        .padding(.vertical)
    }
}

// MARK: - StatisticView
struct StatisticView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - BioSectionView
struct BioSectionView: View {
    @Binding var isEditingBio: Bool
    @Binding var editedBio: String
    var biography: String?
    let onSave: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                
                Text("Bio".localized())
                    .font(.headline)
                Spacer()
                if !isEditingBio {
                    Button(action: {
                        editedBio = biography ?? ""
                        isEditingBio.toggle()
                    }) {
                        Image(systemName: "pencil")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                }
    
                
      
        

            }
            
            if isEditingBio {
                TextEditor(text: $editedBio)
                    .frame(height: 80)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: 1)
                    )
                
                HStack {
                    Button("Save".localized()) {
                        
                    onSave()

                    }
                    .foregroundColor(.red)

                    Button("Cancel".localized()) {
                        isEditingBio = false
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                Text(biography ?? "noBio".localized())
                    .font(.body)
                    .foregroundColor(.secondary)
            }

        }
        .padding(.horizontal)
        .padding(.top,10)
    }
}



#Preview {
}


