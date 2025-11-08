import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.backgroundWhite,
                    Color.backgroundGray
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            BlueGridOverlay()
                .opacity(0.1)
        }
        .ignoresSafeArea()
    }
}

struct BlueGridOverlay: View {
    var body: some View {
        Canvas { context, size in
            let gridSpacing: CGFloat = 30
            
            for x in stride(from: 0, through: size.width, by: gridSpacing) {
                let path = Path { path in
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }
                context.stroke(path, with: .color(.primaryBlue), lineWidth: 0.5)
            }
            
            for y in stride(from: 0, through: size.height, by: gridSpacing) {
                let path = Path { path in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }
                context.stroke(path, with: .color(.primaryBlue), lineWidth: 0.5)
            }
        }
    }
}

#Preview {
    BackgroundView()
}
