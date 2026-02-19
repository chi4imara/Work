import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<15, id: \.self) { index in
                    FloatingBall(
                        size: CGFloat.random(in: 20...40),
                        delay: Double(index) * 0.2,
                        duration: Double.random(in: 4...8),
                        geometry: geometry
                    )
                }
            }
        }
    }
}

struct FloatingBall: View {
    let size: CGFloat
    let delay: Double
    let duration: Double
    let geometry: GeometryProxy
    
    @State private var startX: CGFloat = 0
    @State private var startY: CGFloat = 0
    @State private var endX: CGFloat = 0
    @State private var endY: CGFloat = 0
    @State private var currentX: CGFloat = 0
    @State private var currentY: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(Color.theme.primaryBlue.opacity(0.15))
            .frame(width: size, height: size)
            .position(x: currentX, y: currentY)
            .onAppear {
                generateNewPath()
                startAnimation()
            }
    }
    
    private func generateNewPath() {
        startX = currentX == 0 ? CGFloat.random(in: 0...geometry.size.width) : endX
        startY = currentY == 0 ? CGFloat.random(in: 0...geometry.size.height) : endY
        endX = CGFloat.random(in: 0...geometry.size.width)
        endY = CGFloat.random(in: 0...geometry.size.height)
        currentX = startX
        currentY = startY
    }
    
    private func startAnimation() {
        withAnimation(
            Animation.easeInOut(duration: duration)
                .delay(delay)
        ) {
            currentX = endX
            currentY = endY
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + delay) {
            generateNewPath()
            startAnimation()
        }
    }
}

struct AnimatedBackgroundView: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AnimatedBackground()
            content
        }
    }
}

extension View {
    func withAnimatedBackground() -> some View {
        modifier(AnimatedBackgroundView())
    }
}