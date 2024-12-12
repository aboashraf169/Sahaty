import SwiftUI

// لانشاء text field مخصص
// الهدف منه عند اضافة رمز اظهار كلمة المرور يتم اظهارها والعكس
// قيد التنفيذ حتى وقت اخر
struct PasswordField: View {
    @Binding var password: String
    @State private var isSecure: Bool = true
    var placeholder: String
    var label: String
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 5) {
            Text(label)
                .font(.callout)
                .foregroundStyle(.secondary)
            
            HStack {
                // حالة الاخفاء لكلمة المرور
                if isSecure {
                    SecureField(placeholder, text: $password)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .multilineTextAlignment(.trailing)
                } else {
                    
                // حالة الاظهار لكلمة المرور
                    TextField(placeholder, text: $password)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .multilineTextAlignment(.trailing)
                    
                }
// واقف حتى يتم الحل مشكلة الاتجاهات
                
//                Button(action: {
//                    isSecure.toggle()
//                }) {
//                    Image(systemName: isSecure ? "eye.slash" : "eye")
//                        .foregroundColor(.gray)
//                }

            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.top,10)

    }
}


// MARK: - View

struct SignUpView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var ShowLoginView = false
    @State private var isSuccessAlertPresented = false
    @State private var ShowAleartLoginView = false
    
    // لتغير لون picker للون الازرق
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.accent
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .selected)
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                
 // MARK: - Header
                // العنوان الرئيسي
                VStack(alignment: .trailing, spacing: 8) {
                    Text("بادر بالتسجيل")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("تسجيل جديد")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.accentColor)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 20)
                
                // اختيار نوع المستخدم
                Picker("نوع المستخدم", selection: $viewModel.model.userType) {
                    Text("طبيب").tag(UserType.doctor)
                    Text("مريض").tag(UserType.patient)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal,20)
                ScrollView{
                    
 // MARK: - Center
                    VStack{
                        // الحقول المشتركة
                        Group {
                            
                            // الاسم
                            VStack(alignment: .trailing, spacing: 5) {
                                Text("الاسم")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                
                                TextField("أدخل الاسم كاملاً", text: $viewModel.model.fullName)
                                    .font(.callout)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.top,20)
                            
                            // رسالة الخطأ
                            if !viewModel.fullNameErrorMessage.isEmpty {
                                Text(viewModel.fullNameErrorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                            
                            // البريد الإلكتروني
                            VStack(alignment: .trailing, spacing: 5) {
                                Text("البريد الإلكتروني")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                
                                TextField("أدخل عنوان بريدك الإلكتروني..", text: $viewModel.model.email)
                                    .font(.callout)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .cornerRadius(10)
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.top,10)
                            
                            // رسالة الخطأ
                            if !viewModel.emailErrorMessage.isEmpty {
                                Text(viewModel.emailErrorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            

                            // كلمة المرور
                            // textFiled مخصص تم انشاءه في الاعلى
                            
                            PasswordField(
                                password: $viewModel.model.password,
                                placeholder: "أدخل كلمة المرور",
                                label: "كلمة المرور"
                            )
                            
                            // رسالة الخطأ
                            if !viewModel.passwordErrorMessage.isEmpty {
                                Text(viewModel.passwordErrorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
    
                            // تأكيد كلمة المرور
                            // textFiled مخصص تم انشاءه في الاعلى
                            PasswordField(
                                password: Binding(
                                    get: { viewModel.model.confirmPassword ?? "" },
                                    set: { viewModel.model.confirmPassword = $0.isEmpty ? nil : $0 }
                                ),
                                placeholder: "تأكيد كلمة المرور",
                                label: "تأكيد كلمة المرور"
                            )
                            .padding(.top,10)
                            .padding(.bottom,10)

                            // رسالة الخطأ
                            if !viewModel.confirmPasswordErrorMessage.isEmpty {
                                Text(viewModel.confirmPasswordErrorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        
                        // الحقول الإضافية للطبيب
                        // يظهر فقط في حال كام المستخدم دكتور
                        if viewModel.model.userType == .doctor {
                            Group {
                                // التخصص
                                VStack(alignment: .trailing, spacing: 5) {
                                    Text("التخصص")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                    
                                    TextField("أدخل التخصص", text: Binding(
                                        get: { viewModel.model.specialization ?? "" },
                                        set: { viewModel.model.specialization = $0.isEmpty ? nil : $0 }
                                    ))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(Color(.systemGray6)).cornerRadius(10)
                                    .multilineTextAlignment(.trailing)
                                    
                                    // رسالة الخطأ
                                    if !viewModel.specializationErrorMessage.isEmpty {
                                        Text(viewModel.specializationErrorMessage)
                                            .font(.caption)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 20)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }

                                }
                                
                                // رقم الترخيص
                                VStack(alignment: .trailing, spacing: 5) {
                                    Text("رقم التخصص الوظيفي")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                    
                                    TextField("أدخل رقم التخصص الوظيفي", text: Binding(
                                        get: { viewModel.model.licenseNumber ?? "" },
                                        set: { viewModel.model.licenseNumber = $0.isEmpty ? nil : $0 }
                                    ))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 45)
                                    .background(Color(.systemGray6)).cornerRadius(10)
                                    .multilineTextAlignment(.trailing)
                                    
                                    // رسالة الخطأ
                                    if !viewModel.licenseNumberErrorMessage.isEmpty {
                                        Text(viewModel.licenseNumberErrorMessage)
                                            .font(.caption)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 20)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                                .padding(.top,10)

                             
                            }
                            .padding(.horizontal, 20)
                        }
                        }
                }
// MARK: - Fotear

                Button(action: {
                    if viewModel.validateSignUp() {
                        isSuccessAlertPresented = true
                    }
                }){
                    Text("أنشاء الحساب")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal,20)
                Spacer()
            }
            .padding(.vertical, 20)
            
            // رسالة نجاح
            .alert(viewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                Button("موافق", role: .cancel) {
                    ShowLoginView = true
                }
            }
            .navigationDestination(isPresented: $ShowLoginView) {
                LoginView()
            }
        }

    }
}

// MARK: - Preview
#Preview{
    SignUpView()
}
