import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    
    static let primaryText = primaryBlue
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let whiteText = Color.white
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundWhite, lightGray]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundWhite, Color(red: 0.98, green: 0.98, blue: 1.0)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct GridPatternView: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 20
            
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
                with: .color(ColorTheme.primaryBlue.opacity(0.1)),
                lineWidth: 0.5
            )
        }
    }
}
