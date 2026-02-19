import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryWhite = Color.white
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.7, green: 0.4, blue: 0.9)
    
    static let statusGreen = Color(red: 0.2, green: 0.8, blue: 0.2)
    static let statusYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let statusRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    static let tabBarBackground = Color.white.opacity(0.5)
    static let tabBarBorder = Color.white.opacity(0.6)
}

struct BackgroundView: View {
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
            
            GridPattern()
                .opacity(0.1)
        }
        .ignoresSafeArea()
    }
}

struct GridPattern: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 30
            
            context.stroke(
                Path { path in
                    for x in stride(from: 0, through: size.width, by: spacing) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    }
                    
                    for y in stride(from: 0, through: size.height, by: spacing) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }
                },
                with: .color(.white),
                lineWidth: 1
            )
        }
    }
}
