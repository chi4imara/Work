import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            GridPattern()
                .opacity(0.3)
                .ignoresSafeArea()
        }
    }
}

struct GridPattern: View {
    let spacing: CGFloat = 30
    
    var body: some View {
        Canvas { context, size in
            let path = Path { path in
                for x in stride(from: 0, through: size.width, by: spacing) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }
                
                for y in stride(from: 0, through: size.height, by: spacing) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }
            }
            
            context.stroke(path, with: .color(AppColors.gridWhite), lineWidth: 0.5)
        }
    }
}

#Preview {
    BackgroundView()
}
