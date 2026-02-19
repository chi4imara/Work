import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.bauhaus(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsRowView(
                            icon: "shield.checkered",
                            title: "Privacy Policy",
                            action: {
                                openURL("https://www.freeprivacypolicy.com/live/8e5d0ee4-6b07-4e71-965a-398eea79ebc3")
                            }
                        )
                        
                        SettingsRowView(
                            icon: "envelope",
                            title: "Contact Us",
                            action: {
                                openURL("https://forms.gle/TeLSAggSF7EySaPB8")
                            }
                        )
                        
                        SettingsRowView(
                            icon: "star.bubble",
                            title: "Rate App",
                            action: {
                                requestReview()
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 30)
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.2))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                Text(title)
                    .font(.bauhaus(18, weight: .medium))
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.darkGray.opacity(0.6))
            }
            .padding()
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    SettingsView()
}
