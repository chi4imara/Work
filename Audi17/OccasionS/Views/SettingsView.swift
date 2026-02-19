import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.lumierepolis(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSection(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "star",
                                    title: "Rate App",
                                    iconColor: AppColors.accentOrange
                                ) {
                                    requestAppReview()
                                }
                                
                                Divider()
                                    .background(AppColors.cardBorder)
                                
                                SettingsRow(
                                    icon: "envelope",
                                    title: "Contact Us",
                                    iconColor: AppColors.accentPink
                                ) {
                                    openURL("https://forms.gle/65LNZWsqDsKG6vuc9")
                                }
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                icon: "hand.raised",
                                title: "Privacy Policy",
                                iconColor: AppColors.accentGreen
                            ) {
                                openURL("https://doc-hosting.flycricket.io/occasion-scent-privacy-policy/0f7da36d-d767-449d-93bf-9b3ac803d4b8/privacy")
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("OccasionS")
                                .font(.lumierepolis(16, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
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
                .font(.lumierepolis(18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            content
                .background(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .cornerRadius(16)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.lumierepolis(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
