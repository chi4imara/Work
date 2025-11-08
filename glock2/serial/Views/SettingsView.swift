import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Text("Settings")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            VStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.primaryBlue, Color.secondaryBlue]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "tv")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }
                                
                                Text("Series Manager")
                                    .font(.titleMedium)
                                    .foregroundColor(.textPrimary)
                            }
                            .padding(.vertical, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        
                        VStack(spacing: 16) {
                            SettingsCard(
                                icon: "star.fill",
                                title: "Rate App",
                                subtitle: "Share your feedback",
                                color: .accentOrange,
                                action: {
                                    requestReview()
                                }
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            SettingsCard(
                                icon: "doc.text.fill",
                                title: "Terms",
                                subtitle: "User agreement",
                                color: .accentGreen,
                                action: {
                                    openURL("https://docs.google.com/document/d/1gQMfNxt6YXCGdc9ArBzlp2zuRnqMmnWDcu_z8k36kek/edit?usp=sharing")
                                }
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            SettingsCard(
                                icon: "shield.fill",
                                title: "Privacy Policy",
                                subtitle: "How we protect your data and respect your privacy",
                                color: .statusWaiting,
                                action: {
                                    openURL("https://docs.google.com/document/d/19ZzYyNFPLPDxSuAh1Pht6mI_fcZezF2U79828_UPxxI/edit?usp=sharing")
                                }
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            SettingsCard(
                                icon: "envelope.fill",
                                title: "Contact",
                                subtitle: "Get in touch",
                                color: .primaryBlue,
                                action: {
                                    openURL("https://forms.gle/vT6r53UVSs1WQYPi8")
                                }
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Made with ❤️ for series lovers")
                                .font(.bodyMedium)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                            
                            Text("© 2025 Series Manager")
                                .font(.captionMedium)
                                .foregroundColor(.textSecondary.opacity(0.7))
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Spacer(minLength: 0)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
