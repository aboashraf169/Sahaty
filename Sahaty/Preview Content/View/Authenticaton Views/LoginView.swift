import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var navigateToDoctorView = false
    @State private var navigateToPatientView = false

    // لتغير لون picker للون الأزرق
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }

    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                VStack(alignment: .trailing, spacing: 8) {
                    Text("قم بتسجيل الدخول الآن")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                // اختيار نوع المستخدم
                Picker("", selection: $loginViewModel.model.userType) {
                    Text("مريض").tag(UserType.patient)
                    Text("طبيب").tag(UserType.doctor)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(20)

                // MARK: - Center
                VStack(alignment: .leading, spacing: 5) {
                    // البريد الإلكتروني
                    Text("البريد الإلكتروني")
                        .font(.callout)
                        .foregroundColor(.secondary).opacity(0.7)
                    
                    TextField("أدخل عنوان بريدك الإلكتروني..", text: $loginViewModel.model.email)
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
                    Text("كلمة المرور")
                        .font(.callout)
                        .foregroundColor(.secondary).opacity(0.7)
                    
                    SecureField("أدخل كلمة المرور", text: $loginViewModel.model.password)
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
                    NavigationLink("هل نسيت كلمة المرور؟", destination: ForgotPasswordView(userType: loginViewModel.model.userType))
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
                    Text("تسجيل الدخول")
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
                        Text("التسجيل من خلال")
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
                NavigationLink("إنشاء حساب جديد؟", destination: SignUpView())
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    LoginView()
}
