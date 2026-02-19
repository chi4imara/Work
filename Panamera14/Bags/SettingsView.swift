import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.bellGothic(32, weight: .bold))
                        .foregroundColor(.appDarkBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            SettingsButton(
                                title: "Privacy Policy",
                                icon: "shield.checkerboard",
                                color: .appPrimaryBlue,
                                action: openPrivacyPolicy
                            )
                            
                            SettingsButton(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                color: .appAccentYellow,
                                action: openContactEmail
                            )
                            
                            SettingsButton(
                                title: "Rate App",
                                icon: "star.fill",
                                color: Color.orange,
                                action: rateApp
                            )
                        }
                        .padding(.top, 40)
                        
                        VStack(spacing: 30) {
                            VStack(spacing: 12) {
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 50, weight: .light))
                                    .foregroundColor(.appPrimaryBlue.opacity(0.7))
                                
                                Text("Bag Organizer")
                                    .font(.bellGothic(20, weight: .bold))
                                    .foregroundColor(.appDarkBlue)
                            }
                            .padding(.top, 60)
                            
                            HStack(spacing: 20) {
                                Circle()
                                    .fill(Color.appAccentYellow.opacity(0.3))
                                    .frame(width: 20, height: 20)
                                
                                Circle()
                                    .fill(Color.appPrimaryBlue.opacity(0.4))
                                    .frame(width: 15, height: 15)
                                
                                Circle()
                                    .fill(Color.appAccentYellow.opacity(0.5))
                                    .frame(width: 25, height: 25)
                            }
                            .padding(.top, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.privacypolicies.com/live/227943bc-34e7-403e-81c1-54f9400c1597") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContactEmail() {
        if let url = URL(string: "https://www.privacypolicies.com/live/227943bc-34e7-403e-81c1-54f9400c1597") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.bellGothic(16, weight: .bold))
                    .foregroundColor(.appDarkBlue)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: color.opacity(0.2), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(color.opacity(0.3), lineWidth: 2)
            )
        }
    }
}
