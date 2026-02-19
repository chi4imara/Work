import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: "paintbrush.pointed.fill")
                                .font(.system(size: 60))
                                .foregroundColor(ColorManager.yellow)
                            
                            Text(Constants.App.name)
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorManager.white)
                            
                            Text(Constants.App.description)
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(ColorManager.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 0) {
                            SettingsRow(
                                title: "Privacy Policy",
                                icon: "shield.fill",
                                action: {
                                    openURL(Constants.URLs.privacyPolicy)
                                }
                            )
                            
                            Divider()
                                .overlay {
                                    Color.white
                                }
                            
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                action: {
                                    openURL(Constants.URLs.contactUs)
                                }
                            )
                            
                            Divider()
                                .overlay {
                                    Color.white
                                }
                            
                            SettingsRow(
                                title: "Rate App",
                                icon: "star.fill",
                                action: {
                                    requestReview()
                                }
                            )
                        }
                        .background(ColorManager.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ColorManager.cardBorder, lineWidth: 1)
                        )
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
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

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(ColorManager.yellow)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Color.yellow)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
