import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    settingsContent
                }
            }
        .alert("Rate AromaMix", isPresented: $viewModel.showingRateApp) {
            Button("Cancel", role: .cancel) { }
            Button("Rate Now") {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        } message: {
            Text("Enjoying AromaMix? Please take a moment to rate us in the App Store!")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                appInfoSection
                
                legalSection
                
                supportSection
                
                rateAppSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 120)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppColors.purpleGradientStart.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.purpleGradientStart)
                }
                
                VStack(spacing: 4) {
                    Text("AromaMix")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.darkGray)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var legalSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Legal")
            
            SettingsRow(
                title: "Terms and Conditions",
                icon: "doc.text",
                action: viewModel.openTermsAndConditions
            )
            
            SettingsRow(
                title: "Privacy Policy",
                icon: "hand.raised",
                action: viewModel.openPrivacyPolicy
            )
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Support")
            
            SettingsRow(
                title: "Contact Us",
                icon: "envelope",
                action: viewModel.contactSupport
            )
        }
    }
    
    private var rateAppSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Feedback")
            
            SettingsRow(
                title: "Rate App",
                icon: "star",
                action: viewModel.rateApp
            )
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .padding(.top, 8)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.blueText.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.blueText)
                }
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.darkGray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}
