import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    
    static let lightBlue = Color(red: 0.7, green: 0.85, blue: 0.95)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let softGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let warmOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    
    static let textPrimary = primaryBlue
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let textLight = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    static let gridColor = primaryBlue.opacity(0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            backgroundWhite,
            lightBlue.opacity(0.3),
            backgroundWhite
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct GridBackgroundView: View {
    let gridSize: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for i in stride(from: 0, through: geometry.size.width, by: gridSize) {
                    path.move(to: CGPoint(x: i, y: 0))
                    path.addLine(to: CGPoint(x: i, y: geometry.size.height))
                }
                
                for i in stride(from: 0, through: geometry.size.height, by: gridSize) {
                    path.move(to: CGPoint(x: 0, y: i))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: i))
                }
            }
            .stroke(ColorTheme.gridColor, lineWidth: 0.5)
        }
    }
}

struct BackgroundContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .ignoresSafeArea()
            
            content
        }
    }
}
