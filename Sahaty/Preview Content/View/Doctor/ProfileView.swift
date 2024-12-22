import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State private var isEditingBio = false
    @State private var editedBio: String = ""
    @State private var showImagePicker = false
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showAllAdvices = false
    @State private var showAllArticles = false
    @State private var showAddAdviceView: Bool = false
    @State private var showAddArticleView: Bool = false

    var body: some View {
        NavigationStack {
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
                        biography: viewModel.doctor.biography,
                        onSave: {
                            viewModel.doctor.biography = editedBio
                            isEditingBio = false
                        }
                    )
                    
                    Divider()
                    AdviceSectionView(viewModel: viewModel, showAllAdvices: $showAllAdvices)
                    
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
                AllArticlesView(articles: viewModel.articles)
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
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showAllAdvices: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("النصائح")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showAllAdvices.toggle()
                }) {
                    Text("عرض الكل")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
     
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.advices) { advice in
                        AdviceView(advice: advice)
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
    let articles: [ArticalModel]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(articles) { article in
                        ArticleView(
                            articlesModel: article,
                            articlesViewModel: ArticalsViewModel(),
                            userType: .doctor
                        )
                    }
                }
            }
            .navigationTitle("جميع المقالات")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - ArticlesSectionView
struct ArticlesSectionView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showAllArticles: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("المقالات")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showAllArticles.toggle()
                }) {
                    Text("عرض الكل")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
        
            }
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(viewModel.articles) { article in
                        ArticleView(
                            articlesModel: article,
                            articlesViewModel: ArticalsViewModel(currentUser: .doctor(viewModel.doctor)),
                            userType: .doctor
                        )
                    }
                }
            }
        }
    }
}

struct AllAdvicesView: View {
    @ObservedObject var adviceViewModel: AdviceViewModel // ملاحظة: يتم تمرير الـ ViewModel هنا
    @State private var showAddAdviceSheet = false // عرض شاشة الإضافة/التعديل
    @State private var selectedAdvice: AdviceModel? // النصيحة المحددة للتعديل

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(adviceViewModel.advices.enumerated()), id: \.element.id) { index, advice in
                    HStack {
                        Text(".\(index + 1)") // رقم النصيحة
                            .font(.headline)
                            .foregroundColor(.accentColor)

                            Text(advice.content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        // زر التعديل
                        Button {
                            selectedAdvice = advice
                            adviceViewModel.startEditing(advice: advice) // بدء التعديل
                            showAddAdviceSheet.toggle() // عرض شاشة التعديل
                        } label: {
                            Label("تعديل", systemImage: "pencil")
                        }
                        .tint(.accentColor)

                        // زر الحذف
                        Button(role: .destructive) {
                            if let indexToDelete = adviceViewModel.advices.firstIndex(where: { $0.id == advice.id }) {
                                adviceViewModel.deleteAdvice(at: IndexSet(integer: indexToDelete))
                            }
                        } label: {
                            Label("حذف", systemImage: "trash")
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("جميع النصائح")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("إضافة") {
                    adviceViewModel.clearEditing() // إلغاء أي تعديل سابق
                    showAddAdviceSheet.toggle() // عرض شاشة الإضافة
                })
            .sheet(isPresented: $showAddAdviceSheet) {
                AddAdviceSheetView(adviceViewModel: adviceViewModel)
                    .presentationDetents([.fraction(0.45)])
                    .presentationCornerRadius(30)
            }
        }
    }
}




// MARK: - ProfileHeaderView
struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
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
                } else if let image = viewModel.doctor.profilePicture {
                    Image(image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(Color.accentColor)
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
            
            Text(viewModel.doctor.fullName)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(viewModel.doctor.specialization)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - DoctorStatisticsView
struct DoctorStatisticsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            StatisticView(title: "المتابعون", value: "\(viewModel.doctor.followersCount)")
            StatisticView(title: "المقالات", value: "\(viewModel.doctor.articlesCount)")
            StatisticView(title: "النصائح", value: "\(viewModel.doctor.advicesCount)")
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
                
                Text("السيرة الذاتية")
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
                    Button("حفظ") {
                        
                    onSave()

                    }
                    .foregroundColor(.red)

                    Button("إلغاء") {
                        isEditingBio = false
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                Text(biography ?? "لا توجد سيرة ذاتية متاحة.")
                    .font(.body)
                    .foregroundColor(.secondary)
//                    .multilineTextAlignment(.leading)
            }

        }
//        .multilineTextAlignment(.trailing)
        .padding(.horizontal)
        .padding(.top,10)
    }
}



#Preview {
    let doctor = DoctorModel(
        id: UUID(),
        fullName: "د. محمد اشرف",
        email: "ahmedalkhairy@example.com",
        password: "123456",
        specialization: "أخصائي الغدد الصماء",
        licenseNumber: "12345",
        profilePicture: "post", // اسم الصورة في Assets
        biography: nil,
        articlesCount: 0,
        advicesCount: 0,
        followersCount: 0,
        articles: [],
        advices: [],
        comments: [],
        likedArticles: []
    )

    let viewModel = ProfileViewModel(doctor: doctor)

    ProfileView(viewModel: viewModel)
}


