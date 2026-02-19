import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.lumierepolis(28, weight: .bold))
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.primaryYellow)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        SettingsRowView(
                            icon: "shield.fill",
                            title: "Privacy Policy",
                            iconColor: .primaryYellow
                        ) {
                            openURL("https://www.freeprivacypolicy.com/live/3defb6ab-5e20-43d9-8b93-e08308155d48")
                        }
                        
                        Divider()
                            .background(Color.textSecondary.opacity(0.3))
                            .padding(.leading, 60)
                        
                        SettingsRowView(
                            icon: "envelope.fill",
                            title: "Contact Us",
                            iconColor: .accentOrange
                        ) {
                            openURL("https://forms.gle/hiijDvEGLNBCcBJJA")
                        }
                        
                        Divider()
                            .background(Color.textSecondary.opacity(0.3))
                            .padding(.leading, 60)
                        
                        SettingsRowView(
                            icon: "star.fill",
                            title: "Rate App",
                            iconColor: .accentPink
                        ) {
                            requestReview()
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.cardBackground.opacity(0.3))
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
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
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.lumierepolis(18, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.textSecondary.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
