import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Color.backgroundWhite
                .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.gridOverlay, lineWidth: 1)
                .ignoresSafeArea()
        }
    }
}

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let spacing: CGFloat = 30
        
        var x: CGFloat = 0
        while x <= rect.width {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
            x += spacing
        }
        
        var y: CGFloat = 0
        while y <= rect.height {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
            y += spacing
        }
        
        return path
    }
}
