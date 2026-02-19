import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingPrivacyPolicy = false
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    Text("Settings")
                        .font(FontManager.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 20) {
                        SettingsButton(
                            title: "Rate App",
                            icon: "star.fill",
                            color: ColorTheme.primaryYellow,
                            action: { showRateApp() }
                        )
                        .frame(height: 80)
                        
                        SettingsButton(
                            title: "Privacy Policy",
                            icon: "lock.shield.fill",
                            color: ColorTheme.accentPurple,
                            action: {
                                if let url = URL(string: "https://www.privacypolicies.com/live/939e5228-30c1-4605-92d2-27bb9bf6c32a") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        .frame(height: 80)
                        
                        SettingsButton(
                            title: "Contact Us",
                            icon: "envelope.fill",
                            color: ColorTheme.accentGreen,
                            action: {
                                if let url = URL(string: "https://www.privacypolicies.com/live/939e5228-30c1-4605-92d2-27bb9bf6c32a") {
                                    UIApplication.shared.open(url)
                                }
                            }
                        )
                        .frame(height: 80)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .alert("Rate MoodFood", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Later", role: .cancel) {}
        } message: {
            Text("Enjoying MoodFood? Please take a moment to rate us on the App Store!")
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func showRateApp() {
        showingRateAlert = true
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 40)
                
                Text(title)
                    .font(FontManager.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
            )
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Privacy Policy")
                            .font(FontManager.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text("At MoodFood, we take your privacy seriously. This privacy policy explains how we collect, use, and protect your personal information.")
                            .font(FontManager.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            PolicySection(
                                title: "Information We Collect",
                                content: "We collect information you provide directly to us, such as your name, email address, dietary preferences, and meal planning data."
                            )
                            
                            PolicySection(
                                title: "How We Use Your Information",
                                content: "We use your information to provide personalized meal recommendations, track your energy levels, and improve our services."
                            )
                            
                            PolicySection(
                                title: "Data Protection",
                                content: "We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction."
                            )
                            
                            PolicySection(
                                title: "Contact Us",
                                content: "If you have any questions about this privacy policy, please contact us through the app's contact feature."
                            )
                        }
                        
                        Spacer()
                            .frame(height: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.accentText)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(FontManager.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.accentText)
            
            Text(content)
                .font(FontManager.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.secondaryText)
                .lineSpacing(2)
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    SettingsView()
}
