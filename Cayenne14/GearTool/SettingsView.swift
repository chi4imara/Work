import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Settings")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                
                VStack(spacing: 20) {
                    SettingsButton(
                        title: "Privacy Policy",
                        icon: "shield.checkerboard",
                        color: AppColors.lightBlue
                    ) {
                        openURL("https://www.privacypolicies.com/live/f4c7320f-c423-4ee7-9d10-3efa8f557c18")
                    }
                    
                    SettingsButton(
                        title: "Contact Us",
                        icon: "envelope",
                        color: AppColors.orange
                    ) {
                        openURL("https://www.privacypolicies.com/live/f4c7320f-c423-4ee7-9d10-3efa8f557c18")
                    }
                    
                    SettingsButton(
                        title: "Rate the App",
                        icon: "star",
                        color: AppColors.purple
                    ) {
                        requestReview()
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
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
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding()
            .background(AppColors.cardBackground)
            .cornerRadius(15)
        }
    }
}

#Preview {
    SettingsView()
}
