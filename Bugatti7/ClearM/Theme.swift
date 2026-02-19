import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let primaryWhite = Color.white
    static let primaryBlack = Color.black
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryBlue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [primaryWhite.opacity(0.1), primaryWhite.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct AppFonts {
    static func title(_ size: CGFloat = 24) -> Font {
        return .ubuntu(size, weight: .bold)
    }
    
    static func headline(_ size: CGFloat = 18) -> Font {
        return .ubuntu(size, weight: .medium)
    }
    
    static func body(_ size: CGFloat = 16) -> Font {
        return .ubuntu(size, weight: .regular)
    }
    
    static func caption(_ size: CGFloat = 14) -> Font {
        return .ubuntu(size, weight: .light)
    }
}

struct AppConstants {
    static let cornerRadius: CGFloat = 12
    static let shadowRadius: CGFloat = 8
    static let animationDuration: Double = 0.3
    static let gridSpacing: CGFloat = 20
}

struct GridBackground: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = AppConstants.gridSpacing
            let lineWidth: CGFloat = 0.5
            
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
                with: .color(AppColors.primaryWhite.opacity(0.2)),
                lineWidth: lineWidth
            )
        }
        .allowsHitTesting(false)
    }
}

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                ZStack {
                    AppColors.backgroundGradient
                        .ignoresSafeArea()
                    
                    GridBackground()
                        .ignoresSafeArea()
                }
            }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
}
