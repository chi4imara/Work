import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    
                    VStack(spacing: 32) {
                        legalSection
                        
                        supportSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.primaryPurple.opacity(0.3),
                                AppColors.primaryBlue.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primaryYellow, AppColors.accentOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text("WickMood")
                    .font(.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Scent Collection Manager")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            HStack(spacing: 12) {
                Capsule()
                    .fill(AppColors.primaryPurple.opacity(0.4))
                    .frame(width: 50, height: 3)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryYellow, AppColors.accentOrange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 10, height: 10)
                    .shadow(color: AppColors.primaryYellow.opacity(0.5), radius: 5, x: 0, y: 0)
                
                Capsule()
                    .fill(AppColors.primaryPurple.opacity(0.4))
                    .frame(width: 50, height: 3)
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(.playfairDisplay(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                settingsRow(
                    title: "Terms of Use",
                    icon: "doc.text.fill",
                    color: AppColors.primaryPurple
                ) {
                    openURL("https://www.freeprivacypolicy.com/live/c4cc0afb-a0a9-425f-9af7-970e07965f39")
                }
                
                settingsRow(
                    title: "Privacy Policy",
                    icon: "lock.shield.fill",
                    color: AppColors.accentPink
                ) {
                    openURL("https://www.freeprivacypolicy.com/live/4ad96548-d40e-4318-970d-3d0ea55ac675")
                }
            }
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(.playfairDisplay(size: 20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                settingsRow(
                    title: "Contact Us",
                    icon: "envelope.fill",
                    color: AppColors.accentGreen
                ) {
                    openURL("https://forms.gle/CB9EedjJETx58naS8")
                }
                
                settingsRow(
                    title: "Rate App",
                    icon: "star.fill",
                    color: AppColors.primaryYellow
                ) {
                    requestAppReview()
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Version")
                            .font(.playfairDisplay(size: 12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        Text("1.0.0")
                            .font(.playfairDisplay(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("Build")
                            .font(.playfairDisplay(size: 12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                            .textCase(.uppercase)
                            .tracking(1)
                        
                        Text("2024.1")
                            .font(.playfairDisplay(size: 20, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                        .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    AppColors.primaryPurple.opacity(0.3),
                                    AppColors.primaryBlue.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                
                Text("© 2024 WickMood")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.textLight)
                
                Text("All rights reserved")
                    .font(.playfairDisplay(size: 12, weight: .regular))
                    .foregroundColor(AppColors.textLight.opacity(0.7))
            }
        }
    }
    
    private func settingsRow(
        title: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    color.opacity(0.2),
                                    color.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color, color.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textLight)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(SettingsButtonStyle())
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension SettingsView {
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

#Preview {
    SettingsView()
}
