import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        appInfoSection
                            .padding(.top, AppSpacing.md)
                        
                        legalSection
                        
                        supportSection
                        
                        rateAppSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.lg)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.md)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: AppSpacing.lg) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.primaryPurple,
                                AppColors.accentPink
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: AppColors.primaryPurple.opacity(0.4), radius: 20, x: 0, y: 10)
                
                Image(systemName: "cloud.sun.rain.fill")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.buttonText)
            }
            
            VStack(spacing: AppSpacing.xs) {
                Text("Weather Diary")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.extraLarge)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.extraLarge)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.cardBorder.opacity(0.5),
                                    AppColors.cardBorder.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: AppShadows.medium, radius: 15, x: 0, y: 5)
        )
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Legal")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.sm)
            
            VStack(spacing: AppSpacing.md) {
                SettingsRowView(
                    icon: "doc.text.fill",
                    title: "Terms of Use",
                    iconColor: AppColors.accentPink,
                    action: { openURL("https://www.termsfeed.com/live/c512c2a3-303d-45e2-afc0-dd9ceb35a7fc") }
                )
                
                SettingsRowView(
                    icon: "lock.shield.fill",
                    title: "Privacy Policy",
                    iconColor: AppColors.accentGreen,
                    action: { openURL("https://www.termsfeed.com/live/776a23b9-4ae3-4ae5-9307-f2df8c0d497d") }
                )
            }
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Support")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.sm)
            
            SettingsRowView(
                icon: "envelope.fill",
                title: "Contact Us",
                iconColor: AppColors.accentOrange,
                action: { openURL("https://www.termsfeed.com/live/776a23b9-4ae3-4ae5-9307-f2df8c0d497d") }
            )
        }
    }
    
    private var rateAppSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Feedback")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.sm)
            
            SettingsRowView(
                icon: "star.fill",
                title: "Rate App",
                iconColor: AppColors.primaryPurple,
                action: { requestReview() }
            )
        }
    }
    
    private func openURL(_ urlString: String) {
        HapticFeedback.light()
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        HapticFeedback.medium()
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    iconColor,
                                    iconColor.opacity(0.7)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: iconColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(AppColors.buttonText)
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.large)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.large)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.cardBorder.opacity(0.5),
                                        AppColors.cardBorder.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: AppShadows.light, radius: 8, x: 0, y: 3)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }
}

#Preview {
    SettingsView()
}
