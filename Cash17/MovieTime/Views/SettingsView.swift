import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        appSection
                        
                        legalSection
                        
                        contactSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .alert("Rate Our App", isPresented: $showingRateApp) {
            Button("Cancel", role: .cancel) { }
            Button("Rate Now") {
                requestAppStoreReview()
            }
        } message: {
            Text("Would you like to rate our app on the App Store?")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var appSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("App")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            VStack(spacing: 1) {
                SettingsRowView(
                    icon: "star.circle",
                    title: "Rate App",
                    subtitle: "Help us improve",
                    showChevron: true
                ) {
                    showingRateApp = true
                }
                
                Rectangle()
                    .fill(AppColors.lightGray.opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.leading, 60)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
            )
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Legal")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            VStack(spacing: 1) {
                SettingsRowView(
                    icon: "doc.text",
                    title: "Terms of Use",
                    subtitle: "User agreement",
                    showChevron: true
                ) {
                    openURL("https://docs.google.com/document/d/13p1PHtZwWWZckYa1Joj8TYf6XWgsmIw86T58LiFFWpo/edit?usp=sharing")
                }
                
                Rectangle()
                    .fill(AppColors.lightGray.opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.leading, 60)
                
                SettingsRowView(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    subtitle: "Data protection policy",
                    showChevron: true
                ) {
                    openURL("https://docs.google.com/document/d/1VoYoK4MSssFK8uYw91Tx2T8kAaQNiydzX1k_6MVNcms/edit?usp=sharing")
                }
                
                Rectangle()
                    .fill(AppColors.lightGray.opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.leading, 60)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
            )
        }
    }
    
    private var contactSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Contact")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            VStack(spacing: 1) {
                SettingsRowView(
                    icon: "envelope",
                    title: "Contact Us",
                    subtitle: "Get in touch",
                    showChevron: true
                ) {
                    openURL("https://forms.gle/MLQh6pMP5YzgHBYx9")
                }
                
                Rectangle()
                    .fill(AppColors.lightGray.opacity(0.3))
                    .frame(height: 0.5)
                    .padding(.leading, 60)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
            )
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let showChevron: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FontManager.body)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(subtitle)
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.lightGray)
                }
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.lightGray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
