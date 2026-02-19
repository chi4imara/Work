import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            HStack {
                                SettingsButton(
                                    title: "Privacy Policy",
                                    icon: "lock.shield",
                                    action: openPrivacyPolicy
                                )
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 16) {
                                SettingsButton(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    action: openContactEmail
                                )
                                
                                SettingsButton(
                                    title: "Rate App",
                                    icon: "star",
                                    action: rateApp
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/c3309709-4731-4854-840e-a1060f40dd05") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContactEmail() {
        if let url = URL(string: "https://www.termsfeed.com/live/c3309709-4731-4854-840e-a1060f40dd05") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        requestReview()
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(ColorManager.lightBlue.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(ColorManager.lightBlue)
                }
                
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
        }
    }
}

#Preview {
    SettingsView()
}
