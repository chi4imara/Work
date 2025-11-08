import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        return ZStack {
            VStack(spacing: 0) {
                settingsContentView
            }
        }
    }
    
    
    private var settingsContentView: some View {
        return ScrollView {
            VStack(spacing: 20) {
                appInfoSection
                
                legalSection
                
                supportSection
                
                ratingSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
        }
    }
    
    private var appInfoSection: some View {
        return VStack(spacing: 15) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.primaryOrange)
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.textPrimary)
                }
                
                Text("Home Ideas")
                    .font(.theme.title2)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private var legalSection: some View {
        return VStack(spacing: 0) {
            SettingsRowView(
                title: "Terms of Use",
                icon: "doc.text",
                action: {
                    openURL("https://docs.google.com/document/d/1ZZxla1jzx5fBjIof092LnfmqaKEwIOs9jVYPVYbh7Jc/edit?usp=sharing")
                }
            )
            
            Divider()
                .background(AppColors.cardBorder)
            
            SettingsRowView(
                title: "Privacy Policy",
                icon: "lock.shield",
                action: {
                    openURL("https://docs.google.com/document/d/1QA3GfgYFLLdyQeX1g1h0pbGYGgoUOjPzTXTNyCJrgmc/edit?usp=sharing")
                }
            )
        }
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private var supportSection: some View {
        return VStack(spacing: 0) {
            SettingsRowView(
                title: "Contact Us",
                icon: "envelope",
                action: {
                    openURL("https://forms.gle/y2drWXSh9J95A7xw9")
                }
            )
        }
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private var ratingSection: some View {
        return VStack(spacing: 0) {
            SettingsRowView(
                title: "Rate App",
                icon: "star",
                action: {
                    requestReview()
                }
            )
        }
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
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
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryOrange.opacity(0.2))
                        .frame(width: 35, height: 35)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryOrange)
                }
                
                Text(title)
                    .font(.theme.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
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
