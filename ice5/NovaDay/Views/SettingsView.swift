import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.primaryBlue)
            
            Text("NovaDay")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Your personal memory journal")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SettingsRowView(
                title: "Terms of Use",
                icon: "doc.text",
                action: { openURL("https://www.privacypolicies.com/live/2a2e04bd-7c33-47b6-91ce-afeac4704114") }
            )
            
            Divider()
                .padding(.leading, 60)
            
            SettingsRowView(
                title: "Privacy Policy",
                icon: "lock.shield",
                action: { openURL("https://www.privacypolicies.com/live/663f5f3c-77f1-4f79-8ad7-182abc443b14") }
            )
        }
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SettingsRowView(
                title: "Contact Us",
                icon: "envelope",
                action: { openURL("https://www.privacypolicies.com/live/663f5f3c-77f1-4f79-8ad7-182abc443b14") }
            )
            
            Divider()
                .padding(.leading, 60)
            
            SettingsRowView(
                title: "Rate App",
                icon: "star",
                action: { requestReview() }
            )
        }
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
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
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
