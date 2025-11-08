import SwiftUI

struct AnimatedBackground: View {
    @State private var animatedBalls: [AnimatedBall] = []
    
    struct AnimatedBall: Identifiable {
        let id = UUID()
        var position: CGPoint
        var velocity: CGPoint
        var size: CGFloat
        var opacity: Double
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.theme.backgroundGradientStart,
                        Color.theme.backgroundGradientEnd
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                ForEach(animatedBalls) { ball in
                    Circle()
                        .fill(Color.theme.accentYellow.opacity(ball.opacity))
                        .frame(width: ball.size, height: ball.size)
                        .position(ball.position)
                        .blur(radius: 1)
                }
            }
            .onAppear {
                setupBalls(in: geometry.size)
                startAnimation(in: geometry.size)
            }
        }
        .ignoresSafeArea()
    }
    
    private func setupBalls(in size: CGSize) {
        animatedBalls = (0..<15).map { _ in
            AnimatedBall(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                velocity: CGPoint(
                    x: CGFloat.random(in: -1...1),
                    y: CGFloat.random(in: -1...1)
                ),
                size: CGFloat.random(in: 20...60),
                opacity: Double.random(in: 0.1...0.4)
            )
        }
    }
    
    private func startAnimation(in size: CGSize) {
        Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            updateBalls(in: size)
        }
    }
    
    private func updateBalls(in size: CGSize) {
        for i in animatedBalls.indices {
            var ball = animatedBalls[i]
            
            ball.position.x += ball.velocity.x
            ball.position.y += ball.velocity.y
            
            if ball.position.x <= 0 || ball.position.x >= size.width {
                ball.velocity.x *= -1
            }
            if ball.position.y <= 0 || ball.position.y >= size.height {
                ball.velocity.y *= -1
            }
            
            ball.position.x = max(0, min(size.width, ball.position.x))
            ball.position.y = max(0, min(size.height, ball.position.y))
            
            animatedBalls[i] = ball
        }
    }
}

#Preview {
    AnimatedBackground()
}
