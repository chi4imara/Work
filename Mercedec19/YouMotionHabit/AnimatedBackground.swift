import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorTheme.backgroundGradientStart,
                    ColorTheme.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                MovingParticle(
                    delay: Double(index) * 0.3,
                    duration: Double.random(in: 3...6)
                )
            }
        }
    }
}

struct MovingParticle: View {
    let delay: Double
    let duration: Double
    @State private var position = CGPoint.zero
    @State private var opacity: Double = 0
    
    var body: some View {
        Circle()
            .fill(ColorTheme.primaryWhite.opacity(0.3))
            .frame(width: CGFloat.random(in: 8...20), height: CGFloat.random(in: 8...20))
            .position(position)
            .opacity(opacity)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        position = CGPoint(
            x: CGFloat.random(in: 0...screenWidth),
            y: CGFloat.random(in: 0...screenHeight)
        )
        
        withAnimation(.easeInOut(duration: 1).delay(delay)) {
            opacity = 1
        }
        
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            animateMovement(screenWidth: screenWidth, screenHeight: screenHeight)
        }
    }
    
    private func animateMovement(screenWidth: CGFloat, screenHeight: CGFloat) {
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            position = CGPoint(
                x: CGFloat.random(in: 0...screenWidth),
                y: CGFloat.random(in: 0...screenHeight)
            )
        }
    }
}
