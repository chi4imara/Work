import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.app.backgroundBlue,
                    Color.app.backgroundDarkBlue,
                    Color.app.primaryBlue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridOverlay()
        }
    }
}

struct GridOverlay: View {
    let gridSize: CGFloat = 30
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let verticalLines = Int(geometry.size.width / gridSize) + 1
                for i in 0..<verticalLines {
                    let x = CGFloat(i) * gridSize
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                let horizontalLines = Int(geometry.size.height / gridSize) + 1
                for i in 0..<horizontalLines {
                    let y = CGFloat(i) * gridSize
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.app.gridOverlay, lineWidth: 0.5)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundView()
}
