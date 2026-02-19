import SwiftUI

struct BackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.appBackground,
                        Color.appBackgroundSecondary
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                GridPattern()
                    .stroke(Color.appGrid, lineWidth: 1)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
        .ignoresSafeArea()
    }
}

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let gridSize: CGFloat = 40
        
        for x in stride(from: 0, through: rect.width + gridSize, by: gridSize) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }
        
        for y in stride(from: 0, through: rect.height + gridSize, by: gridSize) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }
        
        return path
    }
}
