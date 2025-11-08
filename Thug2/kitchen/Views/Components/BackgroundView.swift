import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppGradients.primaryBackground
                .ignoresSafeArea()
            
            WebPatternView()
                .opacity(0.1)
                .ignoresSafeArea()
        }
    }
}

struct WebPatternView: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 50
            let lineWidth: CGFloat = 1
            
            for y in stride(from: 0, through: size.height, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.white), lineWidth: lineWidth)
            }
            
            for x in stride(from: 0, through: size.width, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.white), lineWidth: lineWidth)
            }
            
            for y in stride(from: 0, through: size.height, by: spacing * 2) {
                for x in stride(from: 0, through: size.width, by: spacing * 2) {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + spacing, y: y + spacing))
                    context.stroke(path, with: .color(.white), lineWidth: lineWidth * 0.5)
                    
                    path = Path()
                    path.move(to: CGPoint(x: x + spacing, y: y))
                    path.addLine(to: CGPoint(x: x, y: y + spacing))
                    context.stroke(path, with: .color(.white), lineWidth: lineWidth * 0.5)
                }
            }
        }
    }
}

#Preview {
    BackgroundView()
}
