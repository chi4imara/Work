import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.theme.primaryPurple, Color.theme.accentGold],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(rotationAngle))
                            
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(Color.theme.primaryWhite)
                        }
                        .onAppear {
                            withAnimation(
                                Animation.linear(duration: 8)
                                    .repeatForever(autoreverses: false)
                            ) {
                                rotationAngle = 360
                            }
                        }
                        
                        Text("Settings")
                            .font(.ubuntu(28, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                    }
                    .padding(.top, 60)
                    
                    VStack(spacing: 25) {
                        HStack(spacing: 20) {
                            SettingsCard(
                                title: "Terms of Use",
                                subtitle: "Legal information",
                                icon: "doc.text",
                                color: Color.theme.primaryPurple,
                                action: { openURL("https://www.termsfeed.com/live/cd33c0af-0e9e-437b-9e43-1ecea048dfb5") }
                            )
                            
                            SettingsCard(
                                title: "Privacy Policy",
                                subtitle: "Data protection",
                                icon: "lock.shield",
                                color: Color.theme.accentGold,
                                action: { openURL("https://www.termsfeed.com/live/394e3168-276e-4b77-9f2a-13a2523c400d") }
                            )
                        }
                        
                        HStack(spacing: 20) {
                            SettingsCard(
                                title: "Contact Us",
                                subtitle: "Get in touch",
                                icon: "envelope",
                                color: Color.theme.accentMint,
                                action: { openURL("https://www.termsfeed.com/live/394e3168-276e-4b77-9f2a-13a2523c400d") }
                            )
                            
                            SettingsCard(
                                title: "Rate App",
                                subtitle: "Share your feedback",
                                icon: "star",
                                color: Color.theme.accentPink,
                                action: { requestReview() }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 15) {
                        Text("Made with mindfulness")
                            .font(.ubuntuItalic(14, weight: .light))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Color.theme.primaryWhite.opacity(0.3))
                                    .frame(width: 6, height: 6)
                                    .scaleEffect(scale)
                                    .animation(
                                        Animation.easeInOut(duration: 1.5)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.2),
                                        value: scale
                                    )
                            }
                        }
                        .onAppear {
                            scale = 1.2
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                }
                .padding(.bottom, 100)
            }
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
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var hoverOffset: CGFloat = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.ubuntu(12, weight: .light))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(
                        color: color.opacity(0.2),
                        radius: isPressed ? 8 : 15,
                        x: 0,
                        y: isPressed ? 4 : 8
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .offset(y: hoverOffset)
            .onHover { isHovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    hoverOffset = isHovering ? -2 : 0
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
