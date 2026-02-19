import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.primaryBackground
                .ignoresSafeArea()
            
            GridPatternView()
                .ignoresSafeArea()
        }
    }
}

struct GridPatternView: View {
    let gridSize: CGFloat = 30
    
    var body: some View {
        Canvas { context, size in
            let rows = Int(size.height / gridSize) + 1
            let columns = Int(size.width / gridSize) + 1
            
            context.stroke(
                Path { path in
                    for i in 0...columns {
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
                with: .color(AppColors.gridPattern),
                lineWidth: 0.5
            )
        }
    }
}

#Preview {
    BackgroundView()
}
