import SwiftUI
import SwiftUI

struct OtpVerificationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var otpDigits: [String] = ["", "", "", ""] // إدخالات لكل رقم
    @State private var resendTimer: Int = 60 // العداد الزمني
    @State private var canResend: Bool = false
    @State private var timer: Timer?
    @State private var isSuccessAlertPresented = false
    @State private var ShowNewPasswordView = false // عرض شاشة كلمة جديد
    
// MARK: - View
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // العنوان
                VStack(alignment: .trailing, spacing: 8) {
                    Text("قمنا بإرسال رسالة SMS قصيرة تحتوي على رمز التفعيل")
                        .font(.headline)
                        .foregroundColor(Color.accentColor)
                        .multilineTextAlignment(.trailing)
                    
                    Text(viewModel.model.email)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal, 20)
                
                // إدخال رمز OTP
                HStack(spacing: 25) {
                    ForEach(0..<4) { index in
                        TextField("", text: $otpDigits[index])
                            .keyboardType(.numberPad)
                            .frame(width: 60, height: 60)
                            .multilineTextAlignment(.center)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: otpDigits[index]) { _, newValue in
                                if newValue.count > 1 {
                                    otpDigits[index] = String(newValue.prefix(1)) // تقبل رقم واحد فقط
                                }
                            }
                          
                    }
                }
                .padding(.horizontal, 20)
                // رسالة الخطأ
                if !viewModel.otpErrorMessage.isEmpty {
                    Text(viewModel.otpErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                // زر التحقق
                Button(action: {
                    viewModel.otpCode = otpDigits.joined() // دمج الأرقام المدخلة
                    if viewModel.validateOtp() {
                        isSuccessAlertPresented = true
                    }
                }) {
                    Text("تحقق")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
                
                // عداد إعادة إرسال الرمز
                if !canResend {
                    HStack(spacing: 5) {
                        Text("إعادة إرسال الرمز في")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("00:\(String(format: "%02d", resendTimer))")
                            .font(.caption)
                            .foregroundColor(Color.purple)
                    }
                } else {
                    Button(action: resendOtp) {
                        Text("إعادة إرسال الرمز")
                            .font(.caption)
                            .foregroundColor(Color.purple)
                    }
                }
            }
            .padding()
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)
            
            // رسالة النجاح
            .alert(viewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                Button("موافق", role: .cancel) {
                    ShowNewPasswordView = true
                }
            }
            
            // الانتقال لشاشة الكلمة مرور جديدة
            .navigationDestination(isPresented: $ShowNewPasswordView) {
                NewPassworView()
            }
          

        }
    }
    // لانشأء التايمر
    private func startTimer() {
        resendTimer = 60
        canResend = false
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if resendTimer > 0 {
                resendTimer -= 1
            } else {
                canResend = true
                stopTimer()
            }
        }
    }
    
    // لايقاف التايمر
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //اعادة تشغيل التايمر
    private func resendOtp() {
        stopTimer() // أوقف العداد قبل البدء من جديد
        startTimer() // أعد تشغيل العداد
        print("تم إعادة إرسال رمز OTP")
    }
}

// MARK: - Preview

#Preview {
    OtpVerificationView()
}
