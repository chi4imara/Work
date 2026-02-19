import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppGradients.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    headerSection
                    
                    settingsGrid
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, 120)
            }
        }
        .alert("Rate MoodFood", isPresented: $viewModel.showingRateApp) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Later", role: .cancel) { }
        } message: {
            Text("Enjoying MoodFood? Please rate us in the App Store!")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Settings")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Text("Manage your app preferences")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    private var settingsGrid: some View {
        VStack(spacing: AppSpacing.lg) {
            HStack {
                settingsCard(
                    title: "Privacy Policy",
                    subtitle: "Data protection",
                    icon: "shield.fill",
                    color: Color.purple
                ) {
                    viewModel.openPrivacyPolicy()
                }
                .frame(maxWidth: .infinity)
            }
            
            HStack(spacing: AppSpacing.md) {
                settingsCard(
                    title: "Contact Us",
                    subtitle: "Get help",
                    icon: "envelope.fill",
                    color: AppColors.energyColor
                ) {
                    viewModel.openContactEmail()
                }
                .frame(maxWidth: .infinity)
                
                settingsCard(
                    title: "Rate App",
                    subtitle: "Share feedback",
                    icon: "star.fill",
                    color: AppColors.accentYellow
                ) {
                    viewModel.requestAppReview()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func settingsCard(
        title: String,
        subtitle: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(spacing: AppSpacing.xs) {
                    Text(title)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.large)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.large)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(SettingsButtonStyle())
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    SettingsView()
}
