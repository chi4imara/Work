import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 20) {
                        
                        SettingsCardView(
                            title: "Terms of Use",
                            icon: "doc.text.fill",
                            color: AppColors.primaryBlue,
                            isLarge: false
                        ) {
                            openURL("https://www.termsfeed.com/live/c4949926-138c-4726-a312-1aa2b9f49856")
                        }
                        
                        SettingsCardView(
                            title: "Privacy Policy",
                            icon: "lock.shield.fill",
                            color: AppColors.accentGreen,
                            isLarge: false
                        ) {
                            openURL("https://www.termsfeed.com/live/f045b955-126e-4188-acd2-9c676efff791")
                        }
                        
                        SettingsCardView(
                            title: "Contact Us",
                            icon: "envelope.fill",
                            color: AppColors.primaryYellow,
                            isLarge: false
                        ) {
                            openURL("https://www.termsfeed.com/live/f045b955-126e-4188-acd2-9c676efff791")
                        }
                        
                        SettingsCardView(
                            title: "Rate App",
                            icon: "star.fill",
                            color: AppColors.accentOrange,
                            isLarge: false
                        ) {
                            requestReview()
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    decorativeSection
                        .padding(.top, 40)
                        .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Settings")
                    .font(.playfairDisplay(size: 36, weight: .bold))
                    .foregroundColor(AppColors.primaryBlue)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.primaryYellow.opacity(0.3), Color.clear],
                                center: .center,
                                startRadius: 10,
                                endRadius: 30
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "gearshape.2.fill")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.primaryYellow)
                        .rotationEffect(.degrees(45))
                }
            }
            
            HStack {
                Text("Customize your breakfast journal experience")
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textGray)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 30)
    }
    
    private var decorativeSection: some View {
        VStack(spacing: 20) {
            HStack {
                ForEach(0..<5, id: \.self) { index in
                    let icons = ["cup.and.saucer", "leaf", "star", "heart", "sparkles"]
                    
                    Image(systemName: icons[index])
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.primaryBlue.opacity(0.4))
                    
                    if index < 4 {
                        Rectangle()
                            .fill(AppColors.primaryBlue.opacity(0.2))
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            VStack(spacing: 8) {
                Text("Breakfast Journal")
                    .font(.playfairDisplayItalic(size: 20, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
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

struct SettingsCardView: View {
    let title: String
    var subtitle: String? = nil
    let icon: String
    let color: Color
    let isLarge: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: isLarge ? 16 : 12) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [color.opacity(0.2), color.opacity(0.1)],
                                center: .center,
                                startRadius: 10,
                                endRadius: isLarge ? 40 : 30
                            )
                        )
                        .frame(width: isLarge ? 80 : 60, height: isLarge ? 80 : 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: isLarge ? 32 : 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(size: isLarge ? 20 : 16, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                        .multilineTextAlignment(.center)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.playfairDisplay(size: 14))
                            .foregroundColor(AppColors.textGray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, isLarge ? 32 : 24)
            .padding(.horizontal, isLarge ? 24 : 16)
            .background(
                RoundedRectangle(cornerRadius: isLarge ? 25 : 20)
                    .fill(AppColors.backgroundWhite.opacity(0.95))
                    .shadow(color: color.opacity(0.2), radius: 12, x: 0, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: isLarge ? 25 : 20)
                    .stroke(
                        LinearGradient(
                            colors: [color.opacity(0.3), color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(SettingsButtonStyle())
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    SettingsView()
}
