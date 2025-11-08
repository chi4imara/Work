import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    
                    settingsGrid
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.yellow)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(AppColors.backgroundBlue)
                )
            
            VStack(spacing: 8) {
                Text("DreamSign")
                    .font(AppFonts.bold(24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Track Your Prophetic Dreams")
                    .font(AppFonts.regular(14))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(.vertical, 40)
    }
    
    private var settingsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            SettingsCard(
                title: "Terms of Use",
                icon: "doc.text",
                color: Color.blue,
                rotation: -15
            ) {
                openURL("https://docs.google.com/document/d/1uKnAVp4cqDwxPEUbKSGJ_XNV8ISx25WqO1iMRNT0yG4/edit?usp=sharing")
            }
            
            SettingsCard(
                title: "Privacy Policy",
                icon: "hand.raised.fill",
                color: AppColors.green,
                rotation: 10
            ) {
                openURL("https://docs.google.com/document/d/1f9y0OpiDfzj9mXoi9MCtrWyPZpok7c_NE6Dp4AOpzL8/edit?usp=sharing")
            }
            
            SettingsCard(
                title: "Contact Us",
                icon: "envelope.fill",
                color: AppColors.teal,
                rotation: -8
            ) {
                openURL("https://forms.gle/xZHMggATDsAaxNLu9")
            }
            
            SettingsCard(
                title: "Rate App",
                icon: "star.fill",
                color: AppColors.yellow,
                rotation: 12
            ) {
                requestReview()
            }
        }
        .padding(.vertical, 20)
    }
    
    private var footerSection: some View {
        VStack(spacing: 16) {
            Divider()
                .background(AppColors.primaryText.opacity(0.3))
                .padding(.vertical, 20)
            
            VStack(spacing: 8) {
                Text("Version 1.0.0")
                    .font(AppFonts.regular(12))
                    .foregroundColor(AppColors.secondaryText)
                
                Text("Made with ❤️ for dreamers")
                    .font(AppFonts.light(12))
                    .foregroundColor(AppColors.secondaryText.opacity(0.8))
            }
        }
        .padding(.top, 40)
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
    let rotation: Double
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
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(rotation))
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(AppFonts.medium(14))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(
                        color: color.opacity(0.3),
                        radius: isPressed ? 2 : 8,
                        x: 0,
                        y: isPressed ? 1 : 4
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FloatingElement: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let duration: Double
    
    @State private var isAnimating = false
    @State private var randomOffset = CGSize.zero
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size, weight: .light))
            .foregroundColor(color.opacity(0.3))
            .offset(randomOffset)
            .scaleEffect(isAnimating ? 1.2 : 0.8)
            .opacity(isAnimating ? 0.8 : 0.3)
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
                randomOffset = CGSize(
                    width: Double.random(in: -50...50),
                    height: Double.random(in: -50...50)
                )
            }
    }
}

struct AnimatedSettingsBackground: View {
    var body: some View {
        ZStack {
            FloatingElement(
                icon: "star.fill",
                color: AppColors.yellow,
                size: 20,
                duration: 3.0
            )
            .position(x: 80, y: 150)
            
            FloatingElement(
                icon: "moon.stars",
                color: AppColors.purple,
                size: 16,
                duration: 4.0
            )
            .position(x: 300, y: 200)
            
            FloatingElement(
                icon: "sparkles",
                color: AppColors.teal,
                size: 14,
                duration: 2.5
            )
            .position(x: 150, y: 400)
            
            FloatingElement(
                icon: "cloud.fill",
                color: AppColors.green,
                size: 18,
                duration: 3.5
            )
            .position(x: 250, y: 500)
            
            FloatingElement(
                icon: "heart.fill",
                color: AppColors.red,
                size: 12,
                duration: 2.8
            )
            .position(x: 50, y: 600)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}

#Preview {
    SettingsView()
}
