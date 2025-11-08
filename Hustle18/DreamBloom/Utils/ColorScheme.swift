import SwiftUI

extension Color {
    static let dreamBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let dreamYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let dreamWhite = Color.white
    static let dreamPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let dreamPink = Color(red: 1.0, green: 0.6, blue: 0.8)
    static let dreamMint = Color(red: 0.4, green: 0.9, blue: 0.7)
    
    static let primaryBackground = LinearGradient(
        colors: [dreamBlue.opacity(0.8), dreamBlue.opacity(0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let tagColors: [Color] = [
        dreamYellow,
        dreamPurple,
        dreamPink,
        dreamMint,
        Color.orange,
        Color.cyan
    ]
    
    static func tagColor(for tag: String) -> Color {
        let index = abs(tag.hashValue) % tagColors.count
        return tagColors[index]
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.dreamBlue.opacity(0.8),
                    Color.dreamBlue.opacity(0.4),
                    Color.dreamPurple.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            WebPatternView()
                .opacity(0.3)
        }
        .ignoresSafeArea()
    }
}

struct WebPatternView: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 60
            let lineWidth: CGFloat = 1
            
            for y in stride(from: 0, through: size.height, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.dreamBlue.opacity(0.5)), lineWidth: lineWidth)
            }
            
            for x in stride(from: 0, through: size.width, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.dreamBlue.opacity(0.5)), lineWidth: lineWidth)
            }
            
            for y in stride(from: 0, through: size.height, by: spacing * 2) {
                for x in stride(from: 0, through: size.width, by: spacing * 2) {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + spacing, y: y + spacing))
                    context.stroke(path, with: .color(.dreamBlue.opacity(0.3)), lineWidth: lineWidth * 0.5)
                }
            }
        }
    }
}
