import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(AppFonts.bold(size: 23))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.leading, 60)
                    
                    Spacer()
                }
                .padding()
                .padding(.top, 4)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            Image(systemName: "dice.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            Text("Board Game Log")
                                .font(AppFonts.bold(size: 24))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(Color.white)
                        .cornerRadius(20)
                        
                        VStack(spacing: 12) {
                            SettingsButton(
                                icon: "star.fill",
                                title: "Rate App",
                                color: AppColors.accentOrange
                            ) {
                                requestReview()
                            }
                            
                            SettingsButton(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                color: AppColors.primaryBlue
                            ) {
                                openURL("https://forms.gle/zZqPAWSkznxqmUD2A")
                            }
                            
                            SettingsButton(
                                icon: "doc.text.fill",
                                title: "Terms of Use",
                                color: AppColors.secondaryBlue
                            ) {
                                openURL("https://docs.google.com/document/d/1JX4NYu3-pe6WCH00pv29bwUIHOOg3QMsAXfx5g4_oNk/edit?usp=sharing")
                            }
                            
                            SettingsButton(
                                icon: "shield.fill",
                                title: "Privacy Policy",
                                color: AppColors.accentPurple
                            ) {
                                openURL("https://docs.google.com/document/d/15RHuq8YZApWxY9E0j1AMzC7lZzAK6wkJJiVl8xxkcP0/edit?usp=sharing")
                            }
                        }
                    }
                    .padding()
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

struct SettingsButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(AppFonts.medium(size: 17))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

