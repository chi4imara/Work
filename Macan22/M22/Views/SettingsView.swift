import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        settingsGrid
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Settings")
                .font(.playfairDisplay(.bold, size: 28))
                .foregroundColor(AppColors.white)
            
            Text("App preferences and information")
                .font(.playfairDisplay(.regular, size: 16))
                .foregroundColor(AppColors.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 20) {
            
            SettingsCard(
                title: "Terms of Use",
                icon: "doc.text",
                color: Color.yellow
            ) {
                openURL("https://www.privacypolicies.com/live/68a43a50-a6ba-4543-95d7-484ef0a61847")
            }
            
            SettingsCard(
                title: "Privacy Policy",
                icon: "hand.raised",
                color: Color.purple
            ) {
                openURL("https://www.privacypolicies.com/live/d59e7ec6-5670-4426-a112-35b726674872")
            }
            
            SettingsCard(
                title: "Contact Us",
                icon: "envelope",
                color: Color.blue
            ) {
                openURL("https://www.privacypolicies.com/live/d59e7ec6-5670-4426-a112-35b726674872")
            }
            
            SettingsCard(
                title: "Rate App",
                icon: "star",
                color: Color.yellow
            ) {
                requestReview()
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

struct SettingsCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.playfairDisplay(.semiBold, size: 14))
                    .foregroundColor(AppColors.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(AppColors.cardGradient)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .shadow(
                color: AppColors.deepBlue.opacity(0.3),
                radius: isPressed ? 5 : 10,
                x: 0,
                y: isPressed ? 2 : 5
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    SettingsView()
}
