import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: SkinCareViewModel
    @State private var showingRateAlert = false
    @State private var showingSampleDataAlert = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    VStack(spacing: 16) {
                        privacySection
                        
                        supportSection
                        
                        appSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleDataAlert) {
            Button("OK") { }
        } message: {
            Text("Sample procedures, skin diary entries, and progress have been loaded for testing.")
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestAppReview()
            }
            Button("Later") { }
        } message: {
            Text("Would you like to rate our app in the App Store?")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Settings")
                .font(.titleLarge)
                .foregroundColor(ColorManager.primaryText)
            
            Text("Customize your experience")
                .font(.bodyMedium)
                .foregroundColor(ColorManager.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var testingSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Testing")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            SettingsCard(
                icon: "doc.badge.plus",
                title: "Load Sample Data",
                subtitle: "Load demo procedures and diary entries for testing",
                iconColor: ColorManager.lavender,
                action: {
                    viewModel.loadSampleData()
                    showingSampleDataAlert = true
                }
            )
        }
    }
    
    private var privacySection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Privacy")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            SettingsCard(
                icon: "shield.checkerboard",
                title: "Privacy Policy",
                subtitle: "Learn how we protect your data",
                iconColor: ColorManager.lightGreen,
                action: {
                    openURL("https://www.privacypolicies.com/live/ba7e111f-f293-46d8-9734-b29f0dd57264")
                }
            )
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Support")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            VStack(spacing: 8) {
                SettingsCard(
                    icon: "envelope.circle.fill",
                    title: "Contact Us",
                    subtitle: "Get help and support",
                    iconColor: ColorManager.primaryBlue,
                    action: {
                        openURL("https://www.privacypolicies.com/live/ba7e111f-f293-46d8-9734-b29f0dd57264")
                    }
                )
                
                SettingsCard(
                    icon: "star.circle.fill",
                    title: "Rate the App",
                    subtitle: "Share your feedback",
                    iconColor: ColorManager.primaryYellow,
                    action: {
                        showingRateAlert = true
                    }
                )
            }
        }
    }
    
    private var appSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("About")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Skincare Companion")
                        .font(.titleMedium)
                        .foregroundColor(ColorManager.primaryText)
                }
                .padding(.vertical, 20)
                
                VStack(spacing: 8) {
                    Text("Made with care for your skincare journey")
                        .font(.bodyMedium)
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("Your data stays private and secure on your device")
                        .font(.bodySmall)
                        .foregroundColor(ColorManager.secondaryText.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(ColorManager.cardBackground)
            .cornerRadius(16)
            .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
        }
    }
    
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

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(iconColor)
                    .frame(width: 40, height: 40)
                    .background(iconColor.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.bodyLarge)
                        .foregroundColor(ColorManager.darkText)
                        .fontWeight(.medium)
                    
                    Text(subtitle)
                        .font(.bodySmall)
                        .foregroundColor(ColorManager.secondaryText)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(16)
            .background(ColorManager.cardBackground)
            .cornerRadius(12)
            .shadow(color: ColorManager.shadowColor, radius: 3, x: 0, y: 2)
        }
    }
}

#Preview {
    SettingsView(viewModel: SkinCareViewModel())
}
