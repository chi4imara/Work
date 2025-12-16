import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showingRateApp = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    settingsContentView
                    
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContentView: some View {
        ScrollView {
            VStack(spacing: 30) {
                appInfoSection
                
                settingsGrid
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [AppColors.primaryBlue, AppColors.blueGradientEnd],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(AppColors.primaryWhite)
                )
            
            VStack(spacing: 4) {
                Text("MiraTalk")
                    .font(.playfairDisplay(size: 22, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Conversation Starter")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
    
    private var settingsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 20) {
            SettingsCard(
                title: "Rate App",
                icon: "star",
                color: AppColors.primaryYellow
            ) {
                requestAppReview()
            }
            
            SettingsCard(
                title: "Privacy Policy",
                icon: "hand.raised",
                color: AppColors.accentGreen
            ) {
                openURL("https://www.privacypolicies.com/live/301abae4-c375-4232-8a22-e0e33f1762c7")
            }
            
            SettingsCard(
                title: "Terms of Use",
                icon: "doc.text",
                color: AppColors.primaryBlue
            ) {
                openURL("https://www.privacypolicies.com/live/b452a182-d4a1-4421-83c4-d22f94c6ab20")
            }
            
            SettingsCard(
                title: "Contact Us",
                icon: "envelope",
                color: AppColors.accentPink
            ) {
                openURL("https://www.privacypolicies.com/live/301abae4-c375-4232-8a22-e0e33f1762c7")
            }
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(color.opacity(0.1))
                    )
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    SettingsView(viewModel: AppViewModel())
}
