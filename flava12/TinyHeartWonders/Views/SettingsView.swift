import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    settingsContentView
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.appTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var settingsContentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                legalSection
                
                supportSection
                
                appInfoSection
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SettingsRowView(
                title: "Terms and Conditions",
                icon: "doc.text",
                action: {
                    openURL("https://docs.google.com/document/d/1E-9putbEmfwz3-76RK8E8q-D0deb61-nZcSEM9gOkN0/edit?usp=sharing")
                }
            )
            
            Divider()
                .padding(.leading, 50)
            
            SettingsRowView(
                title: "Privacy Policy",
                icon: "hand.raised",
                action: {
                    openURL("https://docs.google.com/document/d/1fFRExBZ8pVvB1bycmR8Aqm40RiVlmO1bmsGkjBMeHtg/edit?usp=sharing")
                }
            )
        }
        .concaveCard(cornerRadius: 8, depth: -5, color: AppColors.cardBackground)
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SettingsRowView(
                title: "Contact Us",
                icon: "envelope",
                action: {
                    openURL("https://forms.gle/Rse9DEt5yH5ZKFJy8")
                }
            )
            
            Divider()
                .padding(.leading, 50)
            
            SettingsRowView(
                title: "Rate the App",
                icon: "star",
                action: {
                        requestReview()
                    }
            )
        }
        .concaveCard(cornerRadius: 8, depth: -5, color: AppColors.cardBackground)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Image(systemName: "lightbulb.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppColors.primaryBlue)
                
                Text("Tiny Heart Wonders")
                    .font(.appHeadline)
                    .foregroundColor(AppColors.primaryText)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .concaveCard(cornerRadius: 8, depth: -5, color: AppColors.cardBackground)
            
            Text("Capture the unexpected moments and remember every surprise in your daily life.")
                .font(.appBody)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.appBody)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
