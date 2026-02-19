import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Settings")
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Manage your preferences")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        AppColors.accent.opacity(0.3),
                                        AppColors.accent.opacity(0.1)
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 25
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.accent)
                            .rotationEffect(.degrees(rotationAngle))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ForEach(viewModel.settingsItems) { item in
                                ModernSettingsCard(item: item, viewModel: viewModel)
                            }
                        }
                        
                        FooterCard()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 10)
                    .repeatForever(autoreverses: false)
            ) {
                rotationAngle = 360
            }
        }
    }
}

struct SettingsHeaderCard: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("App Information")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Version 1.0.0")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "info.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(AppColors.accent)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            AppColors.cardBackground,
                            AppColors.cardBackground.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    AppColors.accent.opacity(0.3),
                                    AppColors.cardBorder
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
    }
}

struct ModernSettingsCard: View {
    let item: SettingsItem
    let viewModel: SettingsViewModel
    @State private var isPressed = false
    
    private var icon: String {
        switch item.action {
        case .privacyPolicy:
            return "shield.checkerboard"
        case .contactEmail:
            return "envelope.fill"
        case .rateApp:
            return "star.fill"
        }
    }
    
    private var gradientColors: [Color] {
        switch item.action {
        case .privacyPolicy:
            return [AppColors.softPink.opacity(0.3), AppColors.softPink.opacity(0.1)]
        case .contactEmail:
            return [AppColors.lightGreen.opacity(0.3), AppColors.lightGreen.opacity(0.1)]
        case .rateApp:
            return [AppColors.lavender.opacity(0.3), AppColors.lavender.opacity(0.1)]
        }
    }
    
    private var iconColor: Color {
        switch item.action {
        case .privacyPolicy:
            return AppColors.softPink
        case .contactEmail:
            return AppColors.lightGreen
        case .rateApp:
            return AppColors.lavender
        }
    }
    
    var body: some View {
        Button(action: {
            viewModel.handleSettingsAction(item.action)
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitleText)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
    }
    
    private var subtitleText: String {
        switch item.action {
        case .privacyPolicy:
            return "View our privacy policy"
        case .contactEmail:
            return "Get in touch with us"
        case .rateApp:
            return "Share your feedback"
        }
    }
}

struct FooterCard: View {
    @State private var sparkleRotation: Double = 0
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.accent)
                    .rotationEffect(.degrees(sparkleRotation))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Made with care")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Personal Catalog of Taste")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.accent.opacity(0.15),
                                AppColors.accent.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                AppColors.accent.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 3)
                    .repeatForever(autoreverses: false)
            ) {
                sparkleRotation = 360
            }
        }
    }
}


#Preview {
    SettingsView()
}
