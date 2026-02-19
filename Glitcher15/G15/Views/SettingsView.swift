import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContentView
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestAppStoreReview()
            }
            Button("Later", role: .cancel) { }
        } message: {
            Text("If you enjoy using our app, please take a moment to rate it. Thanks for your support!")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.playfairBold(size: 28))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                SettingsRowView(
                    icon: "shield.checkered",
                    title: "Privacy Policy",
                    iconColor: AppColors.yellow
                ) {
                    openURL("https://www.freeprivacypolicy.com/live/da62d487-804f-4991-8d65-49e0733513a8")
                }
                
                SettingsRowView(
                    icon: "envelope",
                    title: "Contact Us",
                    iconColor: AppColors.yellow
                ) {
                    openURL("https://forms.gle/ayT7iRpWJbqN5JpR6")
                }
                
                SettingsRowView(
                    icon: "star",
                    title: "Rate the App",
                    iconColor: AppColors.warning
                ) {
                    showingRateAlert = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppStoreReview() {
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
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(FontManager.playfairMedium(size: 17))
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.yellow.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
    }
}

#Preview {
    SettingsView()
}
