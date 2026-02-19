import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: ConversationViewModel
    @State private var isAnimating = false
    @State private var showingRateAlert = false
    @State private var showingLoadSampleAlert = false
    @State private var showingSampleLoadedAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        appInfoSection
                        
                        settingsOptionsSection
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.lg)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Rate Now") {
                requestAppReview()
            }
        } message: {
            Text("If you enjoy using our app, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!")
        }
        .alert("Load Sample Data", isPresented: $showingLoadSampleAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load") {
                viewModel.loadSampleData()
                showingSampleLoadedAlert = true
            }
        } message: {
            Text("This will replace all current conversations with sample data for testing. Continue?")
        }
        .alert("Sample Data Loaded", isPresented: $showingSampleLoadedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sample conversations have been loaded. Check Journal, Search, Calendar and Statistics.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                Text("Settings")
                    .font(AppFonts.title(24))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            
            Divider()
                .background(AppColors.textTertiary)
        }
        .offset(y: isAnimating ? 0 : -50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.8), value: isAnimating)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: AppSpacing.lg) {
            RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                .fill(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(AppColors.textPrimary)
                )
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.8).delay(0.2), value: isAnimating)
            
            VStack(spacing: AppSpacing.md) {
                Text("Conversation Journal")
                    .font(AppFonts.title(22))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Keep conversations clear and remembered. This app helps you capture short notes about conversations and meetings.")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .offset(y: isAnimating ? 0 : 30)
            .opacity(isAnimating ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.8).delay(0.4), value: isAnimating)
        }
        .padding(AppSpacing.xl)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
    }
    
    private var settingsOptionsSection: some View {
        VStack(spacing: AppSpacing.md) {
            SettingsRowView(
                icon: "hand.raised.fill",
                title: "Privacy Policy",
                subtitle: "Learn how we protect your data",
                color: Color.purple,
                animationDelay: 0.6
            ) {
                openURL("https://www.privacypolicies.com/live/b329a822-cb55-4d10-ba0b-a6d777618e96")
            }
            
            SettingsRowView(
                icon: "envelope.fill",
                title: "Contact Us",
                subtitle: "Get in touch with our team",
                color: AppColors.accent,
                animationDelay: 0.7
            ) {
                openURL("https://www.privacypolicies.com/live/b329a822-cb55-4d10-ba0b-a6d777618e96")
            }
            
            SettingsRowView(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Help us improve with your feedback",
                color: AppColors.secondary,
                animationDelay: 0.9
            ) {
                showingRateAlert = true
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let animationDelay: Double
    let action: () -> Void
    
    @State private var isAnimating = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(title)
                        .font(AppFonts.headline(16))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(AppFonts.caption(14))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(AppSpacing.lg)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.md)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppCornerRadius.md)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1.0 : 0.0)
        .animation(.easeOut(duration: 0.6).delay(animationDelay), value: isAnimating)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    SettingsView(viewModel: ConversationViewModel())
}
