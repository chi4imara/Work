import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    
    static let gridBlue = Color(red: 0.7, green: 0.85, blue: 0.95).opacity(0.3)
    static let textBlue = Color(red: 0.1, green: 0.4, blue: 0.7)
    
    static let softPink = Color(red: 0.95, green: 0.7, blue: 0.8)
    static let lightGreen = Color(red: 0.7, green: 0.9, blue: 0.7)
    static let lavender = Color(red: 0.8, green: 0.7, blue: 0.9)
    static let peach = Color(red: 1.0, green: 0.8, blue: 0.7)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let accentText = textBlue
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, Color(red: 0.98, green: 0.98, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.8)
    static let cardShadow = Color.black.opacity(0.1)
}

struct GridBackgroundView: View {
    var body: some View {
        Canvas { context, size in
            let gridSize: CGFloat = 20
            
            context.stroke(
                Path { path in
                    for x in stride(from: 0, through: size.width, by: gridSize) {
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    }
                    
                    for y in stride(from: 0, through: size.height, by: gridSize) {
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }
                },
                with: .color(ColorTheme.gridBlue),
                lineWidth: 0.5
            )
        }
        .ignoresSafeArea()
    }
}
