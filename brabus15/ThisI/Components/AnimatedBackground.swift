import SwiftUI

struct AnimatedBackground: View {
    private let gridSpacing: CGFloat = 24
    private let lineWidth: CGFloat = 0.5
    private let gridOpacity: Double = 0.25
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                DesignSystem.Gradients.primaryBackground
                    .ignoresSafeArea()
                
                Canvas { context, size in
                    var verticalPath = Path()
                    var horizontalPath = Path()
                    
                    var x: CGFloat = 0
                    while x <= size.width {
                        verticalPath.move(to: CGPoint(x: x, y: 0))
                        verticalPath.addLine(to: CGPoint(x: x, y: size.height))
                        x += gridSpacing
                    }
                    
                    var y: CGFloat = 0
                    while y <= size.height {
                        horizontalPath.move(to: CGPoint(x: 0, y: y))
                        horizontalPath.addLine(to: CGPoint(x: size.width, y: y))
                        y += gridSpacing
                    }
                    
                    context.stroke(
                        verticalPath,
                        with: .color(DesignSystem.Colors.primaryText.opacity(gridOpacity)),
                        lineWidth: lineWidth
                    )
                    context.stroke(
                        horizontalPath,
                        with: .color(DesignSystem.Colors.primaryText.opacity(gridOpacity)),
                        lineWidth: lineWidth
                    )
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    AnimatedBackground()
}
