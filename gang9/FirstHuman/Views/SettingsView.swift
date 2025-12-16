import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    SettingsHeader()
                        .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        SettingsSection(title: "Legal & Support") {
                            AnimatedSettingsRow(
                                title: "Terms of Use",
                                icon: "doc.text",
                                color: AppColors.primaryBlue,
                                action: openTerms
                            )
                            
                            AnimatedSettingsRow(
                                title: "Privacy Policy",
                                icon: "lock.shield",
                                color: AppColors.accentGreen,
                                action: openPrivacy
                            )
                        }
                        
                        SettingsSection(title: "Contact & Feedback") {
                            AnimatedSettingsRow(
                                title: "Contact Us",
                                icon: "envelope",
                                color: AppColors.primaryYellow,
                                action: openContact
                            )
                            
                            AnimatedSettingsRow(
                                title: "Rate App",
                                icon: "star",
                                color: AppColors.accentOrange,
                                action: rateApp
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    AppInfoCard()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                }
                .padding(.bottom, 100)
            }
        }
    }
    
    private func openTerms() {
        if let url = URL(string: "https://www.privacypolicies.com/live/2d643c4b-5148-4c3c-a979-d7c2f3354929") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openPrivacy() {
        if let url = URL(string: "https://www.privacypolicies.com/live/817a3f65-caeb-4b3c-b830-ca5c839a9dc9") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContact() {
        if let url = URL(string: "https://www.privacypolicies.com/live/817a3f65-caeb-4b3c-b830-ca5c839a9dc9") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openLicense() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        requestReview()
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                content
            }
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    }
                    .shadow(
                        color: color.opacity(0.1),
                        radius: isPressed ? 2 : 4,
                        x: 0,
                        y: isPressed ? 1 : 2
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
