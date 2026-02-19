import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: "hammer.circle.fill")
                                .font(.system(size: 80, weight: .light))
                                .foregroundColor(ColorManager.accentOrange)
                            
                            VStack(spacing: 4) {
                                Text("CraftRoute")
                                    .font(.ubuntu(24, weight: .bold))
                                    .foregroundColor(ColorManager.primaryText)
                            }
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            SettingsButton(
                                title: "Privacy Policy",
                                subtitle: "Data Protection",
                                icon: "shield.fill",
                                color: ColorManager.accentBlue,
                                action: openPrivacyPolicy
                            )
                            .frame(maxWidth: .infinity)
                            
                            SettingsButton(
                                title: "Contact Us",
                                subtitle: "Get in Touch",
                                icon: "envelope.fill",
                                color: ColorManager.categoryColors["Garden"] ?? ColorManager.accentBlue,
                                action: openContactEmail
                            )
                            .frame(maxWidth: .infinity)
                            
                            SettingsButton(
                                title: "Rate App",
                                subtitle: "Leave a Review",
                                icon: "star.fill",
                                color: ColorManager.accentOrange,
                                action: rateApp
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            Text("Thank you for using CraftRoute!")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                                .multilineTextAlignment(.center)
                            
                            Text("Track your projects, organize your tools, and build something amazing.")
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(ColorManager.secondaryText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                    }
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Rate CraftRoute", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestAppStoreReview()
            }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("Enjoying CraftRoute? Please take a moment to rate us on the App Store!")
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.freeprivacypolicy.com/live/a8f01db4-0f83-476a-ba22-63590e8f3d15") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContactEmail() {
        if let url = URL(string: "https://forms.gle/xQpRwGTqfVRwBXZV8") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        showingRateAlert = true
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(color.opacity(0.2))
                    )
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text(subtitle)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorManager.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(color.opacity(0.3), lineWidth: 2)
                    )
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: isPressed)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    SettingsView()
}
