import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    @AppStorage("useFloatingTabBar") private var useFloatingTabBar = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            headerView
                            
                            legalPrivacySection
                            
                            supportFeedbackSection
                            
                            aboutSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Settings")
                        .font(.nunito(.bold, size: 28))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Manage your preferences")
                        .font(.nunito(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 44, height: 44)
                    .background(AppColors.elementBackground)
                    .clipShape(Circle())
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
    }
    
    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("App Information")
                    .font(.nunito(.semiBold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
        }
    }
    
    private var legalPrivacySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal & Privacy")
                .font(.nunito(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
                HStack(spacing: 16) {
                    SettingsCard(
                        icon: "doc.text",
                        title: "Terms of Use",
                        subtitle: "User Agreement",
                        color: .blue,
                        action: { openURL("https://docs.google.com/document/d/1O1nmL12L-MvV87CX_SqtER7gOOGvH3yiwN2aCjXUPqU/edit?usp=sharing") }
                    )
                    
                    SettingsCard(
                        icon: "hand.raised",
                        title: "Privacy Policy",
                        subtitle: "Data Protection",
                        color: .green,
                        action: { openURL("https://docs.google.com/document/d/17g_Eb9OBpLn8_rGDx1j6Y-X_SIoJmVo0xjO5NnR1jcI/edit?usp=sharing") }
                    )
                }
                .padding(.horizontal, 1)
        }
    }
    
    private var supportFeedbackSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support & Feedback")
                .font(.nunito(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
                HStack(spacing: 16) {
                    SettingsCard(
                        icon: "envelope",
                        title: "Contact Us",
                        subtitle: "Get in Touch",
                        color: .orange,
                        action: { openURL("https://forms.gle/WtS9RgTdWAKKpQFT9") }
                    )
                    
                    SettingsCard(
                        icon: "star.fill",
                        title: "Rate App",
                        subtitle: "Leave a Review",
                        color: .yellow,
                        action: { requestAppReview() }
                    )
                }
                .padding(.horizontal, 1)
        }
        
    }
    
    private var tabBarSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tab Bar Style")
                .font(.nunito(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Floating Tab Bar")
                            .font(.nunito(.semiBold, size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Modern floating design with glass effect")
                            .font(.nunito(.regular, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $useFloatingTabBar)
                        .toggleStyle(SwitchToggleStyle(tint: AppColors.accentBlue))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.elementBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About MuseBoard")
                .font(.nunito(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("MuseBoard is your personal creativity companion. Capture, organize, and develop your ideas with ease.")
                    .font(.nunito(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .lineSpacing(4)
                
                Text("Features:")
                    .font(.nunito(.semiBold, size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                VStack(alignment: .leading, spacing: 8) {
                    FeatureRow(icon: "lightbulb", text: "Capture ideas instantly")
                    FeatureRow(icon: "folder", text: "Organize with categories and tags")
                    FeatureRow(icon: "star", text: "Mark favorites for quick access")
                    FeatureRow(icon: "magnifyingglass", text: "Search and filter your ideas")
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.elementBorder, lineWidth: 1)
                    )
            )
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.nunito(.semiBold, size: 16))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    HStack {
                        Text(subtitle)
                            .font(.nunito(.regular, size: 12))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(2)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.tertiaryText)
                    }
                }
            }
            .padding(16)
            .frame(width: 150, height: 150)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.elementBorder, lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.accentBlue)
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.nunito(.regular, size: 14))
                .foregroundColor(AppColors.secondaryText)
            
            Spacer()
        }
    }
}

struct AlternativeHorizontalSettings: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(0..<5) { index in
                    VStack(spacing: 16) {
                        Circle()
                            .fill(AppColors.tagColors[index % AppColors.tagColors.count])
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: ["doc.text", "hand.raised", "envelope", "star.fill", "questionmark.circle"][index])
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(spacing: 4) {
                            Text(["Terms", "Privacy", "Contact", "Rate", "Help"][index])
                                .font(.nunito(.semiBold, size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text(["Legal", "Policy", "Support", "Review", "FAQ"][index])
                                .font(.nunito(.regular, size: 12))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    .frame(width: 100)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColors.cardGradient)
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
