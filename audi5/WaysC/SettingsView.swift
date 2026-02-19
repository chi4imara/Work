import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: BagViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                        Text("Settings")
                            .font(.bellGothicBold(size: 32))
                            .foregroundColor(Color.theme.textWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    VStack(spacing: 15) {
                        SettingsRow(
                            icon: "shield.checkered",
                            title: "Privacy Policy",
                            color: Color.theme.successGreen,
                            action: openPrivacyPolicy
                        )
                        
                        SettingsRow(
                            icon: "envelope",
                            title: "Contact Us",
                            color: Color.theme.warningOrange,
                            action: openContactEmail
                        )
                        
                        SettingsRow(
                            icon: "star.fill",
                            title: "Rate App",
                            color: Color.theme.accentYellow,
                            action: requestAppReview
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://doc-hosting.flycricket.io/carry-ways-context-privacy-policy/8d2cc95d-a67e-4cbd-9831-52089e73c3fa/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContactEmail() {
        if let url = URL(string: "https://forms.gle/FMofGHKSzyRWSoT57") {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func showAppInfo() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openSupport() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.bellGothicBold(size: 18))
                    .foregroundColor(Color.theme.textWhite)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.textGray)
            }
            .padding()
            .background(Color.theme.cardGradient)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.theme.cardBorder, lineWidth: 1)
            )
        }
    }
}

#Preview {
    SettingsView(viewModel: BagViewModel())
}
