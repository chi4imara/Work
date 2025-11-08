import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            LinearGradient.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Settings")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.top)
                    
                    VStack(spacing: 16) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(AppColors.primaryPurple)
                        
                        Text("ScentaraLog")
                            .font(AppFonts.title)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Your personal scent diary")
                            .font(AppFonts.body)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 12) {
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                title: "Rate App",
                                icon: "star.fill",
                                action: {
                                    requestReview()
                                }
                            )
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                            
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                action: {
                                    openURL(AppConstants.URLs.contactEmail)
                                }
                            )
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                title: "Terms of Use",
                                icon: "doc.text.fill",
                                action: {
                                    openURL(AppConstants.URLs.termsOfUse)
                                }
                            )
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                            
                            SettingsRow(
                                title: "Privacy Policy",
                                icon: "hand.raised.fill",
                                action: {
                                    openURL(AppConstants.URLs.privacyPolicy)
                                }
                            )
                        }
                    }
                    .padding(.top, 30)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient.cardGradient)
                    .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
            )
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.lightText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.clear)
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
