import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.lightBlue,
                    AppColors.primaryBlue,
                    AppColors.darkBlue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .ignoresSafeArea()
        }
    }
}

struct GridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let gridSize: CGFloat = 30
        
        for i in stride(from: 0, through: rect.width, by: gridSize) {
            path.move(to: CGPoint(x: i, y: 0))
            path.addLine(to: CGPoint(x: i, y: rect.height))
        }
        
        for i in stride(from: 0, through: rect.height, by: gridSize) {
            path.move(to: CGPoint(x: 0, y: i))
            path.addLine(to: CGPoint(x: rect.width, y: i))
        }
        
        return path
    }
}

#Preview {
    BackgroundView()
}
