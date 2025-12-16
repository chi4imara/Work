import SwiftUI
import StoreKit
import Foundation

struct SettingsView: View {
    @State private var showingRateAlert = false
    @EnvironmentObject var dataManager: DataManager
    @State private var animateHeader = false
    
    var body: some View {
        ZStack {
            AppColors.mainBackgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    headerSection
                    
                    VStack(spacing: 20) {
                        SettingsCard(
                            title: "Rate App",
                            subtitle: "Love the app? Leave a review",
                            icon: "star.fill",
                            gradient: LinearGradient(
                                colors: [AppColors.primaryYellow, AppColors.primaryYellow.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            iconColor: AppColors.primaryYellow
                        ) {
                            requestReview()
                        }
                        
                            SettingsCard(
                                title: "Privacy Policy",
                                subtitle: "Your data",
                                icon: "lock.shield.fill",
                                gradient: LinearGradient(
                                    colors: [AppColors.primaryPurple, AppColors.primaryPurple.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                iconColor: AppColors.primaryPurple
                            ) {
                                openURL("https://doc-hosting.flycricket.io/wearly-dailyfit-privacy-policy/41d04923-cd2a-4fa9-9676-2c918b0a1ba6/privacy")
                            }
                            
                            SettingsCard(
                                title: "Terms of Use",
                                subtitle: "Legal info",
                                icon: "doc.text.fill",
                                gradient: LinearGradient(
                                    colors: [AppColors.primaryBlue, AppColors.primaryBlue.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                iconColor: AppColors.primaryBlue
                            ) {
                                openURL("https://doc-hosting.flycricket.io/wearly-dailyfit-terms-of-use/b98d797c-24b0-4d0e-b02b-2928e9894474/terms")
                            }
                        
                        SettingsCard(
                            title: "Contact Us",
                            subtitle: "Get in touch with us",
                            icon: "envelope.fill",
                            gradient: LinearGradient(
                                colors: [AppColors.successGreen, AppColors.successGreen.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            iconColor: AppColors.successGreen
                        ) {
                            openURL("https://forms.gle/hozke7EJKsEV2tgG9")
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                .padding(.bottom, 120)
            }
        }
        .alert("Rate DailyFit", isPresented: $showingRateAlert) {
            Button("Not Now", role: .cancel) { }
            Button("Rate") {
                requestReview()
            }
        } message: {
            Text("If you enjoy using DailyFit, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!")
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                animateHeader = true
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primaryYellow.opacity(0.3), AppColors.primaryPurple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .blur(radius: 20)
                    .offset(x: -20, y: -10)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 50, weight: .light))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primaryYellow, AppColors.primaryPurple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(animateHeader ? 1.0 : 0.8)
            .opacity(animateHeader ? 1.0 : 0.0)
            
            Text("Settings")
                .font(.ubuntu(36, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.primaryText, AppColors.primaryText.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(y: animateHeader ? 0 : -10)
                .opacity(animateHeader ? 1.0 : 0.0)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private func requestReview() {
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
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    let iconColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticManager.shared.impact(.medium)
            action()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(gradient)
                        .frame(width: 60, height: 60)
                        .shadow(color: iconColor.opacity(0.4), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(isPressed ? 0.9 : 1.0)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.ubuntu(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [iconColor.opacity(0.3), iconColor.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
    }
}

struct AlternativeSettingsView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    AppColors.mainBackgroundGradient
                        .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            Text("Settings")
                                .font(.ubuntu(32, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                                .padding(.top, 20)
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.1), lineWidth: 2)
                                    .frame(width: 280, height: 280)
                                
                                CircularSettingsButton(
                                    title: "Rate",
                                    icon: "star.fill",
                                    color: AppColors.primaryYellow,
                                    angle: -90
                                ) {
                                }
                                
                                CircularSettingsButton(
                                    title: "Privacy",
                                    icon: "lock.shield",
                                    color: AppColors.primaryPurple,
                                    angle: 0
                                ) {
                                }
                                
                                CircularSettingsButton(
                                    title: "Terms",
                                    icon: "doc.text",
                                    color: AppColors.primaryBlue,
                                    angle: 90
                                ) {
                                }
                                
                                CircularSettingsButton(
                                    title: "Contact",
                                    icon: "envelope.fill",
                                    color: AppColors.successGreen,
                                    angle: 180
                                ) {
                                }
                                
                                Circle()
                                    .fill(AppColors.cardBackground)
                                    .frame(width: 100, height: 100)
                                    .overlay(
                                        Image(systemName: "gearshape.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(AppColors.primaryYellow)
                                    )
                            }
                            .frame(width: 300, height: 300)
                            
                            Spacer(minLength: 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct CircularSettingsButton: View {
    let title: String
    let icon: String
    let color: Color
    let angle: Double
    let action: () -> Void
    
    private var position: CGPoint {
        let radius: CGFloat = 140
        let radians: Double = angle * .pi / 180
        return CGPoint(
            x: radius * CGFloat(cos(radians)),
            y: radius * CGFloat(sin(radians))
        )
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .offset(x: position.x, y: position.y)
    }
}

#Preview {
    SettingsView()
}
