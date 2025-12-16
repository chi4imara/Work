import SwiftUI

struct FloatingOrbs: View {
    let count: Int
    let geometry: GeometryProxy
    @State private var isAnimating = false
    
    init(count: Int = 5, geometry: GeometryProxy) {
        self.count = count
        self.geometry = geometry
    }
    
    var body: some View {
        ForEach(0..<count, id: \.self) { index in
            Circle()
                .fill(orbColor(for: index))
                .frame(width: orbSize(for: index))
                .position(orbPosition(for: index))
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(
                    Animation.easeInOut(duration: Double.random(in: 3...6))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private func orbColor(for index: Int) -> Color {
        switch index % 3 {
        case 0: return AppTheme.Colors.orb1
        case 1: return AppTheme.Colors.orb2
        default: return AppTheme.Colors.orb3
        }
    }
    
    private func orbSize(for index: Int) -> CGFloat {
        let baseSizes: [CGFloat] = [50, 30, 70, 25, 60, 40, 55]
        return baseSizes[index % baseSizes.count]
    }
    
    private func orbPosition(for index: Int) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let positions: [CGPoint] = [
            CGPoint(x: width * 0.1, y: height * 0.2),
            CGPoint(x: width * 0.9, y: height * 0.3),
            CGPoint(x: width * 0.2, y: height * 0.8),
            CGPoint(x: width * 0.8, y: height * 0.9),
            CGPoint(x: width * 0.5, y: height * 0.1),
            CGPoint(x: width * 0.15, y: height * 0.6),
            CGPoint(x: width * 0.85, y: height * 0.7)
        ]
        
        return positions[index % positions.count]
    }
}

#Preview {
    GeometryReader { geometry in
        ZStack {
            AppTheme.Colors.background
                .ignoresSafeArea()
            
            FloatingOrbs(geometry: geometry)
        }
    }
}
