import SwiftUI
import StoreKit

struct SettingsView: View {
    @StateObject private var quoteManager = QuoteManager.shared
    @State private var showingRateApp = false
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        ZStack {
            AppTheme.Gradients.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Load Sample Data", isPresented: $showingSampleDataAlert) {
            Button("Load") {
                quoteManager.loadSampleData()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will add 30 sample quotes to your collection. Continue?")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(AppTheme.Typography.largeTitle, weight: .bold))
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.sm)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            VStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(AppTheme.Colors.accent)
                
                Text("Quote Collection")
                    .font(.playfairDisplay(AppTheme.Typography.title2, weight: .bold))
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
            .padding(AppTheme.Spacing.lg)
            .cardBackground()
        }
    }
    
    private var testingSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Text("Testing")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .semiBold))
                .foregroundColor(AppTheme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Load Sample Data",
                    icon: "square.and.arrow.down",
                    action: { showingSampleDataAlert = true }
                )
            }
            .cardBackground()
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Text("Legal")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .semiBold))
                .foregroundColor(AppTheme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Terms of Use",
                    icon: "doc.text",
                    action: { openURL("https://www.privacypolicies.com/live/d5fd2252-3fa6-4e39-a662-89da8bdbd57d") }
                )
                
                Divider()
                    .background(AppTheme.Colors.border)
                
                SettingsRowView(
                    title: "Privacy Policy",
                    icon: "hand.raised",
                    action: { openURL("https://www.privacypolicies.com/live/9654ea7d-4f22-4d32-8a2a-8717e83f8376") }
                )
            }
            .cardBackground()
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Text("Support")
                .font(.playfairDisplay(AppTheme.Typography.title3, weight: .semiBold))
                .foregroundColor(AppTheme.Colors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Contact Us",
                    icon: "envelope",
                    action: { openURL("https://www.privacypolicies.com/live/9654ea7d-4f22-4d32-8a2a-8717e83f8376") }
                )
                
                Divider()
                    .background(AppTheme.Colors.border)
                
                SettingsRowView(
                    title: "Rate App",
                    icon: "star",
                    action: { requestReview() }
                )
            }
            .cardBackground()
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppTheme.Colors.accent)
                    .frame(width: 24)
                
                Text(title)
                    .font(.playfairDisplay(AppTheme.Typography.body, weight: .medium))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
        }
    }
}

#Preview {
    SettingsView()
}
