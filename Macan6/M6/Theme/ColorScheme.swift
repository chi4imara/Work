import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 0.9)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 0.95)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let yellow = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let brightYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let darkYellow = Color(red: 0.9, green: 0.75, blue: 0.1)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color.black
    
    static let background = primaryBlue
    static let cardBackground = Color.white.opacity(0.15)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
    static let info = Color.blue
    
    static let gridColor = Color.white.opacity(0.2)
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.lightBlue,
                    AppColors.primaryBlue,
                    AppColors.darkBlue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            GridPattern()
                .stroke(AppColors.gridColor, lineWidth: 1)
                .opacity(0.3)
        }
        .ignoresSafeArea()
    }
}

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 30
        
        for x in stride(from: 0, through: rect.width, by: spacing) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        for y in stride(from: 0, through: rect.height, by: spacing) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
}
