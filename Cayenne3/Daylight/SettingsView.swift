import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private let settingsItems: [SettingsItem] = [
        SettingsItem(title: "Privacy Policy", icon: "shield.fill", action: .privacyPolicy),
        SettingsItem(title: "Contact Us", icon: "envelope.fill", action: .contactEmail),
        SettingsItem(title: "Rate App", icon: "star.fill", action: .rateApp)
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        appInfoSection
                        
                        settingsSection
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppTypography.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, 10)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: AppSpacing.md) {
            RoundedRectangle(cornerRadius: AppRadius.large)
                .fill(
                    LinearGradient(
                        colors: [AppColors.lightBlue, AppColors.orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primaryText)
                )
            
            VStack(spacing: 4) {
                Text("Daily Tasks")
                    .font(AppTypography.title)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Keep your daily tasks organized")
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .cardStyle()
    }
    
    private var settingsSection: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(settingsItems) { item in
                SettingsRowView(
                    item: item,
                    onTap: { handleSettingsAction(item.action) }
                )
            }
        }
    }
    
    private var versionSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Built with ❤️ in SwiftUI")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.top, AppSpacing.lg)
    }
    
    private func handleSettingsAction(_ action: SettingsAction) {
        switch action {
        case .privacyPolicy:
            openURL("https://www.freeprivacypolicy.com/live/50c13b1f-789e-44e9-864a-e64236a49d20")
            
        case .contactEmail:
            openURL("https://forms.gle/kUuKzhY8dwkejfu59")
            
        case .rateApp:
            requestAppReview()
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRowView: View {
    let item: SettingsItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: item.icon)
                    .font(.title3)
                    .foregroundColor(AppColors.lightBlue)
                    .frame(width: 24, height: 24)
                
                Text(item.title)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(AppSpacing.md)
            .cardStyle()
        }
    }
}

#Preview {
    SettingsView(viewModel: TaskViewModel())
}
