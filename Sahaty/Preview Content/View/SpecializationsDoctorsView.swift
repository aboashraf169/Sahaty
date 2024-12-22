import SwiftUI

struct SpecializationsDoctorsView: View {
    @EnvironmentObject var appState: AppState // استقبال حالة التطبيق
    @StateObject var viewModel = SpecializationViewModel() // تمرير ViewModel
    @State private var searchText: String = "" // نص البحث

    var body: some View {
        NavigationStack {
            VStack {
                // شريط البحث
                HStack {
               
//                    HeaderHomeSectionView(userType: .doctor)
                    
                    TextField("ابحث في الواجهة", text: $searchText)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                Spacer()
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        )
                }
                .padding()

                // قائمة الأطباء حسب التخصص
                List {
                    ForEach(viewModel.filteredSpecializations(searchText: searchText)) { specialization in
                        Section(header: Text(specialization.name)
                                    .font(.headline)
                                    .foregroundColor(.accentColor)) {
                            ForEach(specialization.doctors) { doctor in
                                DoctorRowView(doctor: doctor)
                                    .environmentObject(appState)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("الأطباء")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - DoctorRowView
struct DoctorRowView: View {
    
    let doctor: DoctorModel
    @EnvironmentObject var appState: AppState // استقبال حالة التطبيق

    var body: some View {
        HStack {
            // صورة الطبيب
            if let profilePicture = doctor.profilePicture {
                Image(profilePicture)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image("doctor")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
            }

            // معلومات الطبيب
            VStack(alignment: .leading) {
                Text("د.\(doctor.fullName)")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)

                Text(doctor.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // زر المحادثة
            Button(action: {
                appState.selectedTabPatients = .chat
                print("بدء المحادثة مع \(doctor.fullName)")
            }) {
                HStack {
                    Image(systemName: "message.fill")
                    Text("محادثة")
                   
                }
                .foregroundColor(.white)
                .padding(10)
                .background(Color.accentColor)
                .cornerRadius(10)
            }
        }
        .padding(.vertical, 5)
    }
}



// MARK: - Preview
struct DoctorsListView_Previews: PreviewProvider {
    static var previews: some View {
        SpecializationsDoctorsView()
    }
}
