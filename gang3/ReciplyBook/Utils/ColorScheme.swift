import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightGray],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite, Color(red: 0.98, green: 0.98, blue: 1.0)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct GridOverlay: View {
    let spacing: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let verticalLines = Int(geometry.size.width / spacing)
                for i in 0...verticalLines {
                    let x = CGFloat(i) * spacing
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                let horizontalLines = Int(geometry.size.height / spacing)
                for i in 0...horizontalLines {
                    let y = CGFloat(i) * spacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 0.5)
        }
        .allowsHitTesting(false)
    }
}
