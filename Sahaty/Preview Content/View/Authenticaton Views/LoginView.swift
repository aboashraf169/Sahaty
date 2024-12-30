import SwiftUI

struct LoginView: View {
    
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var navigateToDoctorView = false
    @State private var navigateToPatientView = false

    // لتغير لون picker للون الأزرق
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    func toggleLanguage() {
        appLanguage = (appLanguage == "ar") ? "en" : "ar"
        UserDefaults.standard.set(appLanguage, forKey: "appLanguage") // تحديث اللغة في UserDefaults
    }

    // MARK: - View
    var body: some View {
        NavigationStack {
            
            VStack {
                // MARK: - Header
                HStack {
                    Spacer()

                    Button {
                        toggleLanguage()

                    } label: {
                        Image(systemName: "globe")
                            .font(.title)
                            .foregroundStyle(.accent)
                        Text("".localized())

                    }

                }
                .padding(.horizontal)
                .padding(.vertical,10)
               
                VStack(alignment: .trailing, spacing: 8) {
                    Text("login_now".localized())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // اختيار نوع المستخدم
                Picker("", selection: $loginViewModel.model.userType) {
                    Text("patient".localized()).tag(UserType.patient)
                    Text("doctor".localized()).tag(UserType.doctor)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)

                // MARK: - Center
                VStack(alignment: .leading, spacing: 5) {
                    // البريد الإلكتروني
                    Text("email".localized())
                        .font(.callout)
                        .foregroundColor(.secondary).opacity(0.7)
                    
                    TextField("enter_email".localized(), text: $loginViewModel.model.email)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .multilineTextAlignment(.leading)

                    if !loginViewModel.emailErrorMessage.isEmpty {
                        Text(loginViewModel.emailErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 5) {
                    // كلمة المرور
                    Text("password".localized())
                        .font(.callout)
                        .foregroundColor(.secondary).opacity(0.7)
                    
                    SecureField("enter_password".localized(), text: $loginViewModel.model.password)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .multilineTextAlignment(.leading)

                    if !loginViewModel.passwordErrorMessage.isEmpty {
                        Text(loginViewModel.passwordErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // رابط "نسيت كلمة المرور؟"
                HStack {
                    NavigationLink("forgot_password".localized(), destination: ForgotPasswordView(userType: loginViewModel.model.userType))
                        .font(.callout)
                        .foregroundColor(.secondary.opacity(0.7))
                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)

                // زر تسجيل الدخول
                Button(action: {
                    if loginViewModel.validateLogin() {
                        if loginViewModel.model.userType == .doctor {
                            navigateToDoctorView = true
                        } else {
                            navigateToPatientView = true
                        }
                    }
                }) {
                    Text("login".localized())
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .navigationDestination(isPresented: $navigateToDoctorView) {
                    DoctorTabBarView()
                }
                .navigationDestination(isPresented: $navigateToPatientView) {
                    PatientTabBarView()
                }

                // MARK: - Footer
                VStack(spacing: 10) {
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.secondary.opacity(0.4))
                        Text("login_with".localized())
                            .font(.system(size: 15))
                            .foregroundColor(.secondary).opacity(0.7)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.secondary.opacity(0.4))
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 20)

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
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary, lineWidth: 1).opacity(0.5)
                        )
                        .cornerRadius(10)

                        Button(action: {
                            // هنا سيتم الانتقال لحساب الفيسبوك
                        }) {
                            Image("facebook")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(Color.accentColor)
                        }
                        .frame(width: 100, height: 60)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary, lineWidth: 1).opacity(0.5)
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
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.secondary, lineWidth: 1).opacity(0.5)
                        )
                        .cornerRadius(10)
                    }
                    .padding(.top)
                }

                // الانتقال لشاشة إنشاء حساب
                NavigationLink("sign_up".localized(), destination: SignUpView())
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
            }
            .direction(appLanguage) // تطبيق الاتجاه
            .environment(\.locale, .init(identifier: appLanguage)) // تطبيق اللغة المختارة

        }
    }
}

// MARK: - Preview

#Preview {
    LoginView()
}
