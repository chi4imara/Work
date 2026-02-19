import SwiftUI

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContent
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.ibmPlexMono(28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                settingsSection(title: "App") {
                    SettingsRow(
                        icon: "star.fill",
                        title: "Rate App",
                        iconColor: AppColors.primaryYellow,
                        action: { settingsViewModel.requestAppReview() }
                    )
                }
                
                settingsSection(title: "Support") {
                    SettingsRow(
                        icon: "envelope.fill",
                        title: "Contact Us",
                        iconColor: AppColors.primaryBlue,
                        action: { settingsViewModel.openContactEmail() }
                    )
                }
                
                settingsSection(title: "Legal") {
                    SettingsRow(
                        icon: "doc.text.fill",
                        title: "Privacy Policy",
                        iconColor: AppColors.accentPurple,
                        action: { settingsViewModel.openPrivacyPolicy() }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ibmPlexMono(16, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content()
            }
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.ibmPlexMono(16, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                Rectangle()
                    .fill(isPressed ? AppColors.textSecondary.opacity(0.05) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}
