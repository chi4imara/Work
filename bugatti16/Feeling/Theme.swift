import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryBlue = Color(red: 0.2, green: 0.5, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let secondary = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let accent = Color(red: 0.9, green: 0.4, blue: 0.8)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let softPink = Color(red: 0.95, green: 0.7, blue: 0.8)
    static let lightGreen = Color(red: 0.5, green: 0.85, blue: 0.6)
    static let background = Color.white
    static let surface = Color(red: 0.98, green: 0.98, blue: 1.0)
    static let textPrimary = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let textDark = Color(red: 0.15, green: 0.15, blue: 0.2)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.6)
    static let cardBackground = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static var backgroundGradient: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [background, surface, Color(red: 0.95, green: 0.97, blue: 1.0)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

extension Color {
    static let appPrimaryYellow = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let appPrimaryBlue = Color(red: 0.2, green: 0.5, blue: 1.0)
    static let appLavender = Color(red: 0.6, green: 0.5, blue: 0.9)
    static let appSoftPink = Color(red: 0.95, green: 0.7, blue: 0.8)
    static let appLightGreen = Color(red: 0.5, green: 0.85, blue: 0.6)
    static let appPeach = Color(red: 1.0, green: 0.8, blue: 0.6)
    static let appTextSecondary = Color(red: 0.4, green: 0.4, blue: 0.6)
}

struct AppFonts {
    static func playfairRegular(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Regular", size: size)
    }
    
    static func playfairMedium(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Medium", size: size)
    }
    
    static func playfairBold(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Bold", size: size)
    }
    
    static func playfairSemiBold(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-SemiBold", size: size)
    }
}

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

struct AppRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
}

struct AppAnimations {
    static let quick = Animation.easeInOut(duration: 0.2)
    static let smooth = Animation.easeInOut(duration: 0.3)
    static let bouncy = Animation.spring(response: 0.6, dampingFraction: 0.8)
}

struct AnimatedBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.background,
                    AppColors.surface,
                    Color(red: 0.95, green: 0.97, blue: 1.0)
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(
                Animation.easeInOut(duration: 8.0).repeatForever(autoreverses: true),
                value: animateGradient
            )
            
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(AppColors.primary.opacity(Double.random(in: 0.05...0.15)))
                    .frame(width: CGFloat.random(in: 10...40))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animateGradient
                    )
            }
        }
        .onAppear {
            animateGradient = true
        }
    }
}

struct FloatingBubblesView: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(AppColors.primary.opacity(Double.random(in: 0.08...0.2)))
                        .frame(width: CGFloat.random(in: 20...50))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .scaleEffect(animate ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.15),
                            value: animate
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear { animate = true }
    }
}
