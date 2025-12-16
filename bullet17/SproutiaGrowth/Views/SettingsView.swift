import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(AppColors.lightBlue.opacity(0.2))
                                .frame(width: 200, height: 200)
                                .offset(x: -100, y: -50)
                            
                            Circle()
                                .fill(AppColors.primaryYellow.opacity(0.1))
                                .frame(width: 150, height: 150)
                                .offset(x: 120, y: 80)
                            
                            VStack(spacing: 30) {
                                HStack {
                                    Text("Settings")
                                        .font(.playfair(.bold, size: 28))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                }
                                
                                VStack(spacing: 16) {
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(AppColors.softGreen)
                                    
                                    VStack(spacing: 4) {
                                        Text("Sproutia Growth")
                                            .font(.playfair(.bold, size: 24))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                }
                                .padding(24)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(AppColors.cardGradient)
                                        .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                                )
                                
                                HStack(spacing: 16) {
                                    SettingsCard(
                                        icon: "doc.text",
                                        title: "Terms & Conditions",
                                        subtitle: "Legal information",
                                        color: AppColors.primaryBlue,
                                        action: { openURL("https://www.privacypolicies.com/live/037c1b45-2d8a-430d-ae80-ad0c03e02b8b") }
                                    )
                                    
                                    SettingsCard(
                                        icon: "hand.raised",
                                        title: "Privacy Policy",
                                        subtitle: "Your data protection",
                                        color: AppColors.softGreen,
                                        action: { openURL("https://www.privacypolicies.com/live/f9defe2f-3e8b-4594-b6c5-7fdd7d7e6844") }
                                    )
                                    
                                }
                                
                                HStack(spacing: 16) {
                                    
                                    SettingsCard(
                                        icon: "envelope",
                                        title: "Contact",
                                        subtitle: "Get in touch",
                                        color: AppColors.primaryYellow,
                                        action: { openURL("https://www.privacypolicies.com/live/f9defe2f-3e8b-4594-b6c5-7fdd7d7e6844") }
                                    )
                                    
                                    SettingsCard(
                                        icon: "star",
                                        title: "Rate App",
                                        subtitle: "Share your feedback",
                                        color: AppColors.warningOrange,
                                        action: { requestReview() }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    var isWide: Bool = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: isWide ? 32 : 28, weight: .light))
                    .foregroundColor(color)
                    .frame(height: 35)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.playfair(.semiBold, size: isWide ? 18 : 13))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.playfair(.regular, size: isWide ? 14 : 12))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(isWide ? 2 : 3)
                }
            }
            .padding(isWide ? 24 : 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: isWide ? 16 : 12)
                    .fill(AppColors.cardGradient)
                    .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: isWide ? 16 : 12)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(SettingsButtonStyle())
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    SettingsView()
}
