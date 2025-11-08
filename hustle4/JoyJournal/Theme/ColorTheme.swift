import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let lightBlue = Color(red: 0.7, green: 0.85, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
    
    static let background = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let webBackground = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static let primaryText = Color.black
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let lightText = lightBlue
    static let darkText = darkBlue
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let accent = Color(red: 0.3, green: 0.7, blue: 0.9)
    
    static let tabBarBackground = Color.white.opacity(0.95)
    static let tabBarSelected = primaryBlue
    static let tabBarUnselected = Color.gray
    
    static let sidebarBackground = Color.white.opacity(0.98)
    static let sidebarSelected = primaryBlue
    static let sidebarUnselected = Color.gray.opacity(0.8)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color(red: 0.95, green: 0.97, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.99, green: 0.995, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueWebGradient = LinearGradient(
        gradient: Gradient(colors: [
            lightBlue.opacity(0.1),
            primaryBlue.opacity(0.05),
            lightBlue.opacity(0.08)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct WebPatternBackground: View {
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            Canvas { context, size in
                let spacing: CGFloat = 40
                let lineWidth: CGFloat = 0.5
                
                context.stroke(
                    Path { path in
                        for y in stride(from: 0, through: size.height, by: spacing) {
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: size.width, y: y))
                        }
                        
                        for x in stride(from: 0, through: size.width, by: spacing) {
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: size.height))
                        }
                    },
                    with: .color(ColorTheme.lightBlue.opacity(0.3)),
                    lineWidth: lineWidth
                )
                
                context.stroke(
                    Path { path in
                        for y in stride(from: 0, through: size.height, by: spacing * 2) {
                            for x in stride(from: 0, through: size.width, by: spacing * 2) {
                                path.move(to: CGPoint(x: x, y: y))
                                path.addLine(to: CGPoint(x: x + spacing, y: y + spacing))
                            }
                        }
                    },
                    with: .color(ColorTheme.primaryBlue.opacity(0.2)),
                    lineWidth: lineWidth * 0.7
                )
            }
            .ignoresSafeArea()
        }
    }
}
