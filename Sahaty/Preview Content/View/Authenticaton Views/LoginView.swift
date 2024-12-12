import SwiftUI

struct LoginView: View {
    
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @State private var NavigateToDoctorView = false
    @State private var NavigatToPationtView = false

 // لتغير لون picker للون الازرق
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
// MARK: - View
    
    var body: some View {
        NavigationStack {
            VStack{
// MARK: - Header
                // العنوان
                VStack(alignment: .trailing, spacing: 8) {
                    Text("قم بتسجيل الدخول الآن")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 20)
                
                // اختيار نوع المستخدم
                Picker("", selection: $authenticationViewModel.model.userType) {
                    Text("مريض").tag(UserType.patient)
                    Text("طبيب").tag(UserType.doctor)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)
                
                
                
                
// MARK: - Center
                // البريد الإلكتروني
                VStack(alignment: .trailing, spacing: 5) {
                    Text("البريد الإلكتروني")
                        .font(.callout)
                        .foregroundColor(.black).opacity(0.7)
                    
                    TextField("أدخل عنوان بريدك الإلكتروني..", text: $authenticationViewModel.model.email)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.systemGray6)).cornerRadius(10)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.horizontal, 20)
                .padding(.top,20)
                // نص الخطأ للبريد
                if !authenticationViewModel.emailErrorMessage.isEmpty {
                    Text(authenticationViewModel.emailErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                
                // كلمة المرور
                VStack(alignment: .trailing, spacing: 5) {
                    Text("كلمة المرور")
                        .font(.callout)
                        .foregroundColor(.black).opacity(0.7)
                    
                    SecureField("أدخل كلمة المرور", text: $authenticationViewModel.model.password)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.systemGray6)).cornerRadius(10)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.horizontal, 20)
                .padding(.top,20)
                
                // نص الخطأ للبريد
                if !authenticationViewModel.passwordErrorMessage.isEmpty {
                    Text(authenticationViewModel.passwordErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                
       
                // رابط "نسيت كلمة المرور؟"
                HStack {
                    Spacer()
                    NavigationLink("هل نسيت كلمة المرور؟", destination: ForgotPasswordView(userType: authenticationViewModel.model.userType))
                        .font(.callout)
                        .foregroundColor(.black.opacity(0.7))
                }
                .padding(.horizontal, 25)
                .padding(.top,10)
                

                // زر تسجيل الدخول
                Button(action: {
                    if authenticationViewModel.validateLogin() {
                        if authenticationViewModel.model.userType == .doctor {
                            NavigateToDoctorView = true
                        }else{
                            NavigatToPationtView = true
                        }
                    }
                }) {
                    Text("تسجيل الدخول")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top,20)
                
           //مؤقت
                .navigationDestination(isPresented: $NavigateToDoctorView) {
                    DoctorDashboardView()
                       }
                .navigationDestination(isPresented: $NavigatToPationtView) {
                    PatientDashboardView()
                       }
        // هيتم اعتماد هذه الكود بعد لانتهاء من اضافة api
                
//                .fullScreenCover(isPresented: $shouldNavigateToDoctorView) {
//                    DoctorDashboardView()
//                      }
                
// MARK: - Fotear
                // تسجيل من خلال
                VStack(spacing: 10) {
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.secondary.opacity(0.4))
                        Text("التسجيل من خلال")
                            .font(.system(size: 15))
                            .foregroundColor(.black).opacity(0.7)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.secondary.opacity(0.4))
                    }
                    .padding(.horizontal,30)
                    .padding(.top,20)
                    //
                    HStack(spacing: 15) {
                        Button(action: {
                            // هنا سيتم الانتقال لحساب جوجل
                        }) {
                            Image("googel")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.accent)
                        }
                        .frame(width: 100, height: 60)
                            .background(Color.clear) // خلفية شفافة
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary, lineWidth: 1).opacity(0.5) // الحدود بلون الحواف
                            )
                            .cornerRadius(10)

                
                        Button(action: {
                            // هنا سيتم الانتقال لحساب الفيس بوك
                        }) {
                            Image("facebook")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.accentColor)
                        }
                        .frame(width: 100, height: 60)
                            .background(Color.clear) // خلفية شفافة
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary, lineWidth: 1).opacity(0.5) // الحدود بلون الحواف
                            )
                            .cornerRadius(10)

                        
                        Button(action: {
                            // هنا سيتم الانتقال لحساب التويتر
                        }) {
                            Image("twitter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.accent)
                        }
                        .frame(width: 100, height: 60)
                            .background(Color.clear) // خلفية شفافة
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.secondary, lineWidth: 1).opacity(0.5) // الحدود بلون الحواف
                            )
                            .cornerRadius(10)
                        

                    }
                    .padding(.top)
                }
                
                // الانتقال لشاشة انشاء حساب
                NavigationLink("إنشاء حساب جديد؟", destination: SignUpView())
                    .font(.callout)
                    .foregroundColor(.black)
                    .padding(.top,20)
            }
            
        }
    }
}

// MARK: - Preview

#Preview {
    LoginView()
}
