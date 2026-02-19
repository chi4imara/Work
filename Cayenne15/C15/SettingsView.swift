import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @State private var showingPrivacyPolicy = false
    @State private var showingRateAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Settings")
                .font(FontManager.playfairBold(size: 28))
                .foregroundColor(ColorManager.primaryText)
                .padding(.top, 20)
                .padding(.bottom, 30)
            
            VStack(spacing: 20) {
                HStack(spacing: 15) {
                    SettingsButton(
                        icon: "shield.fill",
                        title: "Privacy Policy",
                        subtitle: "Data Protection",
                        color: ColorManager.lightBlue
                    ) {
                        openURL("https://www.privacypolicies.com/live/09d25828-c4e9-4d04-9ca6-d951599ac96b")
                    }
                    
                    SettingsButton(
                        icon: "envelope.fill",
                        title: "Contact Us",
                        subtitle: "Get in Touch",
                        color: ColorManager.orange
                    ) {
                        openURL("https://www.privacypolicies.com/live/09d25828-c4e9-4d04-9ca6-d951599ac96b")
                    }
                }
                
                SettingsButton(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Leave a Review",
                    color: ColorManager.green
                ) {
                    requestReview()
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            VStack(spacing: 8) {
                Text("Car Care Tracker")
                    .font(FontManager.playfairMedium(size: 16))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(.bottom, 50)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    var isWide: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(FontManager.playfairSemiBold(size: 16))
                        .foregroundColor(ColorManager.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: isWide ? .infinity : 140)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorManager.darkBlue.opacity(0.4))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    }
            )
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.primaryGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Privacy Policy")
                            .font(FontManager.playfairBold(size: 24))
                            .foregroundColor(ColorManager.primaryText)
                            .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Data Collection")
                                .font(FontManager.playfairSemiBold(size: 18))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text("This app stores your car maintenance records locally on your device. We do not collect, transmit, or store any personal information on external servers.")
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorManager.secondaryText)
                                .lineSpacing(4)
                            
                            Text("Data Storage")
                                .font(FontManager.playfairSemiBold(size: 18))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text("All your car care records are stored locally using iOS UserDefaults. This data remains on your device and is not shared with any third parties.")
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorManager.secondaryText)
                                .lineSpacing(4)
                            
                            Text("Data Security")
                                .font(FontManager.playfairSemiBold(size: 18))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text("Your data is protected by iOS security measures. We recommend keeping your device updated with the latest iOS version for optimal security.")
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorManager.secondaryText)
                                .lineSpacing(4)
                            
                            Text("Contact")
                                .font(FontManager.playfairSemiBold(size: 18))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Text("If you have any questions about this privacy policy, please contact us through the app settings.")
                                .font(FontManager.playfairRegular(size: 16))
                                .foregroundColor(ColorManager.secondaryText)
                                .lineSpacing(4)
                        }
                        
                        Spacer().frame(height: 50)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorManager.orange)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
