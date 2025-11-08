import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color.appBackgroundWhite
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.5)
                .ignoresSafeArea()
            
            LinearGradient(
                colors: [
                    Color.appLightBlue.opacity(0.5),
                    Color.appBackgroundWhite.opacity(0.8),
                    Color.appLightBlue.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

struct GridPattern: View {
    let gridSize: CGFloat = 30
    
    var body: some View {
        Canvas { context, size in
            let path = Path { path in
                for x in stride(from: 0, through: size.width, by: gridSize) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }
                
                for y in stride(from: 0, through: size.height, by: gridSize) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }
            }
            
            context.stroke(path, with: .color(.appGridBlue), lineWidth: 0.5)
        }
    }
}

#Preview {
    BackgroundView()
}
