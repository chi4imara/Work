import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let secondary = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let accent = Color(red: 0.9, green: 0.6, blue: 0.3)
    static let success = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let warning = Color(red: 1.0, green: 0.7, blue: 0.3)
    static let danger = Color(red: 1.0, green: 0.4, blue: 0.4)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let backgroundPrimary = LinearGradient(
        colors: [
            Color(red: 0.2, green: 0.6, blue: 0.9),
            Color(red: 0.4, green: 0.8, blue: 1.0),
            Color(red: 0.3, green: 0.7, blue: 0.95)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let ballColor = Color.white.opacity(0.3)
}

struct AppFonts {
    static func title(_ size: CGFloat = 24) -> Font {
        return .ubuntu(size, weight: .bold)
    }
    
    static func headline(_ size: CGFloat = 20) -> Font {
        return .ubuntu(size, weight: .medium)
    }
    
    static func body(_ size: CGFloat = 16) -> Font {
        return .ubuntu(size)
    }
    
    static func caption(_ size: CGFloat = 14) -> Font {
        return .ubuntu(size, weight: .light)
    }
    
    static func button(_ size: CGFloat = 16) -> Font {
        return .ubuntu(size, weight: .medium)
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

struct AppCornerRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
}

struct AnimatedBackground: View {
    @State private var animatingBalls: [AnimatedBall] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            ForEach(animatingBalls.indices, id: \.self) { index in
                Circle()
                    .fill(AppColors.ballColor)
                    .frame(width: animatingBalls[index].size, height: animatingBalls[index].size)
                    .position(animatingBalls[index].position)
                    .animation(
                        Animation.linear(duration: animatingBalls[index].duration)
                            .repeatForever(autoreverses: false),
                        value: animatingBalls[index].position
                    )
            }
        }
        .onAppear {
            createAnimatedBalls()
        }
    }
    
    private func createAnimatedBalls() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<6 {
            let ball = AnimatedBall(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                ),
                size: CGFloat.random(in: 20...60),
                duration: Double.random(in: 8...15)
            )
            animatingBalls.append(ball)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for index in animatingBalls.indices {
                animatingBalls[index].position = CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                )
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            for index in animatingBalls.indices {
                animatingBalls[index].position = CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                )
            }
        }
    }
}

struct AnimatedBall {
    var position: CGPoint
    let size: CGFloat
    let duration: Double
}
