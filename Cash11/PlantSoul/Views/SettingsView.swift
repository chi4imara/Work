import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            ColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: DesignConstants.largePadding) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                    }
                    .padding(DesignConstants.largePadding)
                    .padding(.bottom, 100) 
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.title)
                .fontWeight(.bold)
                .foregroundColor(ColorScheme.lightText)
            
            Spacer()
        }
        .padding(.horizontal, DesignConstants.largePadding)
        .padding(.vertical, DesignConstants.mediumPadding)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            VStack(spacing: DesignConstants.mediumPadding) {
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .fill(ColorScheme.accent.opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 32))
                            .foregroundColor(ColorScheme.accent)
                    )
                
                VStack(spacing: 4) {
                    Text("PlantSoul")
                        .font(FontManager.headline)
                        .fontWeight(.bold)
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text("Plant Care Companion")
                        .font(FontManager.body)
                        .foregroundColor(ColorScheme.lightText.opacity(0.8))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(DesignConstants.largePadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SettingsRowView(
                icon: "doc.text",
                title: "Terms of Use",
                subtitle: "Read our terms and conditions"
            ) {
                openURL("https://docs.google.com/document/d/140zS2jluBNI7pgTp-01u6BghKyR2pZR-I99ziNlHixI/edit?usp=sharing")
            }
            
            Divider()
                .background(ColorScheme.mediumGray.opacity(0.3))
            
            SettingsRowView(
                icon: "hand.raised",
                title: "Privacy Policy",
                subtitle: "Learn about data protection"
            ) {
                openURL("https://docs.google.com/document/d/1yaa_in5929ewguGfiU2BKPjL1GA5GNcxVztAyPyZUWc/edit?usp=sharing")
            }
            
            Divider()
                .background(ColorScheme.mediumGray.opacity(0.3))
            
            SettingsRowView(
                icon: "envelope",
                title: "Contact Us",
                subtitle: "Get in touch with support"
            ) {
                openURL("https://forms.gle/RhNVcv6P1QcyfDyE9")
            }
        }
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SettingsRowView(
                icon: "star",
                title: "Rate App",
                subtitle: "Help us improve with your feedback"
            ) {
                requestReview()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var appVersionSection: some View {
        VStack(spacing: 8) {
            Text("Version 1.0.0")
                .font(FontManager.caption)
                .foregroundColor(ColorScheme.lightText.opacity(0.6))
            
            Text("Made with ❤️ for plant lovers")
                .font(FontManager.caption)
                .foregroundColor(ColorScheme.lightText.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, DesignConstants.largePadding)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignConstants.mediumPadding) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(ColorScheme.accent)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FontManager.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text(subtitle)
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.lightText.opacity(0.9))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(ColorScheme.mediumGray)
            }
            .padding(DesignConstants.mediumPadding)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}

