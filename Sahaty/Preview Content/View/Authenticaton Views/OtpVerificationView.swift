import SwiftUI

struct OtpVerificationView: View {
    @StateObject private var otpViewModel = OtpVerificationViewModel()
    @State private var otpDigits: [String] = ["", "", "", ""] // إدخالات لكل رقم
    @State private var resendTimer: Int = 60 // العداد الزمني
    @State private var canResend: Bool = false
    @State private var timer: Timer?
    @State private var isSuccessAlertPresented = false
    @State private var showNewPasswordView = false // عرض شاشة كلمة جديد
    @AppStorage("appLanguage") private var appLanguage = "ar" // اللغة المفضلة

    // MARK: - View
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // MARK: - Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("otp_sent_message".localized()) // قمنا بإرسال رسالة SMS قصيرة تحتوي على رمز التفعيل
                        .font(.headline)
                        .foregroundColor(Color.accentColor)
                        .multilineTextAlignment(.leading)
                    
                    Text(otpViewModel.model.email)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)

                // MARK: - OTP Input
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
                .environment(\.layoutDirection, .leftToRight) // تثبيت الاتجاه من اليسار إلى اليمين


                // Error Message
                if !otpViewModel.otpErrorMessage.isEmpty {
                    Text(otpViewModel.otpErrorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // MARK: - Verify Button
                Button(action: {
                    otpViewModel.model.otpCode = otpDigits.joined() // دمج الأرقام المدخلة
                    if otpViewModel.validateOtp() {
                        isSuccessAlertPresented = true
                    }
                }) {
                    Text("verify".localized()) // تحقق
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                // MARK: - Resend Timer
                if !canResend {
                    HStack(spacing: 5) {
                        Text("resend_otp_in".localized()) // إعادة إرسال الرمز في
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("00:\(String(format: "%02d", resendTimer))")
                            .font(.caption)
                            .foregroundColor(Color.purple)
                    }
                } else {
                    Button(action: resendOtp) {
                        Text("resend_otp".localized()) // إعادة إرسال الرمز
                            .font(.caption)
                            .foregroundColor(Color.purple)
                    }
                }
            }
            .padding()
            .onAppear(perform: startTimer)
            .onDisappear(perform: stopTimer)

            // Success Alert
            .alert(otpViewModel.successMessage, isPresented: $isSuccessAlertPresented) {
                Button("ok".localized(), role: .cancel) { // موافق
                    showNewPasswordView = true
                }
            }

            // Navigate to New Password View
            .navigationDestination(isPresented: $showNewPasswordView) {
                NewPasswordView()
            }
        }
         .direction(appLanguage) // اتجاه النصوص
         .environment(\.locale, .init(identifier: appLanguage)) // اللغة المختارة
    }

    // MARK: - Timer Management
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

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func resendOtp() {
        stopTimer() // أوقف العداد قبل البدء من جديد
        startTimer() // أعد تشغيل العداد
        otpViewModel.resendOtp()
    }
}

// MARK: - Preview
#Preview {
    OtpVerificationView()
}
