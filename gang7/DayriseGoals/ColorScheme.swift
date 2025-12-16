import SwiftUI

struct AppColors {
    static let backgroundBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let gridWhite = Color.white.opacity(0.3)
    static let textYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let elementPurple = Color(red: 0.6, green: 0.3, blue: 0.8)
    
    static let softGreen = Color(red: 0.5, green: 0.8, blue: 0.6)
    static let warmOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    static let lightPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let deepBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    
    static let primaryText = textYellow
    static let secondaryText = Color.white.opacity(0.8)
    static let accent = elementPurple
    static let cardBackground = Color.white.opacity(0.1)
    static let buttonBackground = elementPurple
    static let selectedBackground = warmOrange
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.backgroundBlue,
                    AppColors.deepBlue,
                    AppColors.backgroundBlue.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            GridPattern()
                .stroke(AppColors.gridWhite, lineWidth: 1)
                .opacity(0.5)
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
