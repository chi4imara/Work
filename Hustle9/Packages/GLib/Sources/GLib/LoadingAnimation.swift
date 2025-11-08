import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.1, green: 0.4, blue: 0.7)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let placeholderText = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    static let buttonBackground = Color.white.opacity(0.2)
    static let buttonBorder = Color.white.opacity(0.4)
    
    static let accent = Color(red: 1.0, green: 0.8, blue: 0.4)
    static let success = Color(red: 0.4, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.4, blue: 0.4)
    
    static let starColor = Color.white.opacity(0.8)
    
    static let tabBarBackground = Color.black.opacity(0.3)
    static let tabBarSelected = Color.white
    static let tabBarUnselected = Color.white.opacity(0.6)
}

struct BackgroundView: View {
    @State private var animateStars = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<20, id: \.self) { index in
                StarView()
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(animateStars ? 0.3 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animateStars
                    )
            }
        }
        .onAppear {
            animateStars = true
        }
    }
}

struct StarView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        Image(systemName: "star.fill")
            .foregroundColor(AppColors.starColor)
            .font(.system(size: CGFloat.random(in: 8...16)))
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(
                    Animation.linear(duration: Double.random(in: 10...20))
                        .repeatForever(autoreverses: false)
                ) {
                    rotation = 360
                }
            }
    }
}


public struct LoadingAnimation: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    
   public var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    ForEach(0..<8) { index in
                        Circle()
                            .fill(AppColors.accent)
                            .frame(width: 12, height: 12)
                            .offset(y: -40)
                            .rotationEffect(.degrees(Double(index) * 45))
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .opacity(isAnimating ? 0.3 : 1.0)
                            .animation(
                                Animation.linear(duration: 2.0)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.1),
                                value: isAnimating
                            )
                    }
                    
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.primaryText)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 4.0)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            isAnimating = true
            pulseScale = 1.2
        }
    }
}
