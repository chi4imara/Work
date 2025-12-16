import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    Text("Settings")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.textWhite)
                    
                    Text("App preferences and information")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(AppColors.textWhite.opacity(0.8))
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                ScrollView {
                    VStack(spacing: 30) {
                        settingsSectionView(title: "App") {
                            VStack(spacing: 15) {
                                settingsRowView(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    subtitle: "Help us improve",
                                    action: {
                                        requestAppReview()
                                    }
                                )
                            }
                        }
                        
                        settingsSectionView(title: "Legal") {
                            VStack(spacing: 15) {
                                settingsRowView(
                                    icon: "doc.text.fill",
                                    title: "Terms of Use",
                                    subtitle: "User agreement",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/93645455-39e6-4c31-9ca4-2fdcbcd939ac")
                                    }
                                )
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                    .frame(maxWidth: .infinity)
                                
                                settingsRowView(
                                    icon: "hand.raised.fill",
                                    title: "Privacy Policy",
                                    subtitle: "Data protection policy",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/96b712e4-aaf9-410a-ba95-c4c9366e759a")
                                    }
                                )
                            }
                        }
                        
                        settingsSectionView(title: "Contact") {
                            VStack(spacing: 15) {
                                settingsRowView(
                                    icon: "envelope.fill",
                                    title: "Contact Us",
                                    subtitle: "Get in touch",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/96b712e4-aaf9-410a-ba95-c4c9366e759a")
                                    }
                                )
                            }
                        }
                        
                        VStack(spacing: 10) {
                            Text("StreakMind")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(AppColors.textWhite)
                            
                            Text("Track your habit-breaking streaks")
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(AppColors.textWhite.opacity(0.5))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func settingsSectionView<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.textWhite)
                .padding(.horizontal, 5)
            
            VStack(spacing: 1) {
                content()
            }
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(AppColors.textWhite.opacity(0.1), lineWidth: 1)
            )
        }
    }
    
    private func settingsRowView(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(AppColors.accentYellow.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textWhite)
                    
                    Text(subtitle)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.textWhite.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textWhite.opacity(0.5))
            }
            .padding(20)
            .background(Color.clear)
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

#Preview {
    SettingsView()
}
