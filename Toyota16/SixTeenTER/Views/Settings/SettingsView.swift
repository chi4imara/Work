import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingPrivacyPolicy = false
    @State private var showingRateAlert = false
    @State private var showingSampleDataAlert = false
    @State private var sampleDataLoaded = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(.bold, size: AppConstants.headerFontSize))
                        .foregroundColor(AppColors.primaryText)
                    Spacer()
                }
                .padding(.horizontal, AppConstants.mediumSpacing)
                .padding(.vertical, AppConstants.mediumSpacing)
                
                ScrollView {
                    VStack(spacing: AppConstants.largeSpacing) {
                        AppInfoSection()
                        SupportSection(showingPrivacyPolicy: $showingPrivacyPolicy, showingRateAlert: $showingRateAlert)
                        LegalSection(showingPrivacyPolicy: $showingPrivacyPolicy)
                    }
                    .padding(.horizontal, AppConstants.mediumSpacing)
                    .padding(.top, AppConstants.mediumSpacing)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Rate Now") { requestAppStoreReview() }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("If you enjoy using Focus & Strength, please take a moment to rate us on the App Store. Your feedback helps us improve!")
        }
        .alert("Load Sample Data", isPresented: $showingSampleDataAlert) {
            Button("Load") {
                DataManager.shared.loadSampleData()
                sampleDataLoaded = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will add sample tasks, challenges, and 7 days of progress data for testing. Existing data will be kept.")
        }
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        CardView {
            HStack(spacing: AppConstants.mediumSpacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppConstants.mediumCornerRadius)
                        .fill(AppColors.primaryOrange.opacity(0.25))
                        .frame(width: 64, height: 64)
                    Image(systemName: "target")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(AppColors.primaryOrange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Focus & Strength")
                        .font(.ubuntu(.bold, size: AppConstants.largeFontSize))
                        .foregroundColor(AppColors.primaryText)
                    Text("Your personal productivity companion")
                        .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                        .foregroundColor(AppColors.secondaryText)
                }
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}

struct SupportSection: View {
    @Binding var showingPrivacyPolicy: Bool
    @Binding var showingRateAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Support")
            CardView {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "envelope.fill",
                        iconColor: Color.blue,
                        title: "Contact Us",
                        showChevron: false
                    ) {
                        if let webURL = URL(string: "https://www.privacypolicies.com/live/c5e556b3-72a5-4107-8c53-3609c3bceb80") {
                            UIApplication.shared.open(webURL)
                        }
                    }
                    divider
                    SettingsRow(
                        icon: "star.fill",
                        iconColor: AppColors.primaryOrange,
                        title: "Rate App",
                        showChevron: false
                    ) {
                        showingRateAlert = true
                    }
                }
            }
        }
    }
    
    private var divider: some View {
        Rectangle()
            .fill(AppColors.separatorColor)
            .frame(height: 1)
            .padding(.leading, 52)
    }
    
    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.ubuntu(.medium, size: 11))
            .foregroundColor(AppColors.tertiaryText)
            .padding(.leading, 4)
    }
    
    private func openEmail() {
        if let url = URL(string: "mailto:support@focusstrength.app"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else if let webURL = URL(string: "https://google.com") {
            UIApplication.shared.open(webURL)
        }
    }
}

struct LegalSection: View {
    @Binding var showingPrivacyPolicy: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionLabel("Legal & Data")
            CardView {
                VStack(spacing: 0) {
                    SettingsRow(icon: "shield.fill", iconColor: AppColors.success, title: "Privacy Policy", showChevron: true) {
                        if let webURL = URL(string: "https://www.privacypolicies.com/live/c5e556b3-72a5-4107-8c53-3609c3bceb80") {
                            UIApplication.shared.open(webURL)
                        }
                    }
                }
            }
        }
    }
    
    private var divider: some View {
        Rectangle()
            .fill(AppColors.separatorColor)
            .frame(height: 1)
            .padding(.leading, 52)
    }
    
    private func sectionLabel(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.ubuntu(.medium, size: 11))
            .foregroundColor(AppColors.tertiaryText)
            .padding(.leading, 4)
    }
}

struct TestingSection: View {
    @Binding var showingSampleDataAlert: Bool
    @Binding var sampleDataLoaded: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Testing".uppercased())
                .font(.ubuntu(.medium, size: 11))
                .foregroundColor(AppColors.tertiaryText)
                .padding(.leading, 4)
            CardView {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "square.and.arrow.down.fill",
                        iconColor: AppColors.primaryOrange,
                        title: "Load Sample Data",
                        showChevron: false
                    ) {
                        showingSampleDataAlert = true
                    }
                    if sampleDataLoaded {
                        Text("Sample data loaded. Restart or switch tabs to see it.")
                            .font(.ubuntu(.regular, size: 11))
                            .foregroundColor(AppColors.success)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 4)
                    }
                }
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let showChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppConstants.mediumSpacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.tertiaryText)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct WebView: View {
    let url: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient.ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer()
                    Image(systemName: "safari.fill")
                        .font(.system(size: 56, weight: .light))
                        .foregroundColor(AppColors.primaryOrange)
                    VStack(spacing: 12) {
                        Text("Opening Web Page")
                            .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                            .foregroundColor(AppColors.primaryText)
                        Text("This will redirect you to our website")
                            .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    Button("Open in Browser") {
                        if let webURL = URL(string: url) {
                            UIApplication.shared.open(webURL)
                        }
                        dismiss()
                    }
                    .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 200, height: AppConstants.buttonHeight)
                    .background(AppColors.buttonGradient)
                    .cornerRadius(AppConstants.mediumCornerRadius)
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
            .navigationTitle("Web Page")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(AppColors.primaryOrange)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let webURL = URL(string: url) {
                    UIApplication.shared.open(webURL)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
