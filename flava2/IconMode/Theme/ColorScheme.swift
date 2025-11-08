import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondary = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let accent = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.2)
    static let warning = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let danger = Color(red: 1.0, green: 0.2, blue: 0.2)
    
    static let background = Color.white
    static let cardBackground = Color(red: 0.95, green: 0.98, blue: 1.0)
    static let gridOverlay = Color(red: 0.7, green: 0.9, blue: 1.0)
    
    static let textPrimary = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let textSecondary = Color(red: 0.4, green: 0.3, blue: 0.7)
    static let textLight = Color.white
    
    static let primaryLight = Color(red: 0.2, green: 0.6, blue: 1.0).opacity(0.3)
    static let secondaryLight = Color(red: 0.6, green: 0.4, blue: 1.0).opacity(0.3)
    static let accentLight = Color(red: 1.0, green: 0.8, blue: 0.0).opacity(0.3)
    static let successLight = Color(red: 0.2, green: 0.8, blue: 0.2).opacity(0.3)
    static let dangerLight = Color(red: 1.0, green: 0.2, blue: 0.2).opacity(0.3)
    static let warningLight = Color(red: 1.0, green: 0.6, blue: 0.0).opacity(0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.95, green: 0.98, blue: 1.0),
            Color(red: 0.9, green: 0.95, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color(red: 0.92, green: 0.96, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct GridBackgroundView: View {
    let gridSize: CGFloat = 20
    
    var body: some View {
        Canvas { context, size in
            let rows = Int(size.height / gridSize) + 1
            let cols = Int(size.width / gridSize) + 1
            
            context.stroke(
                Path { path in
                    for i in 0...cols {
                        let x = CGFloat(i) * gridSize
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: size.height))
                    }
                    
                    for i in 0...rows {
                        let y = CGFloat(i) * gridSize
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: size.width, y: y))
                    }
                },
                with: .color(AppColors.gridOverlay.opacity(0.3)),
                lineWidth: 0.5
            )
        }
    }
}
