import SwiftUI

struct AnimatedBackground: View {
    @State private var balls: [MovingBall] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(balls) { ball in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [ball.color.opacity(0.3), ball.color.opacity(0.1)],
                            center: .center,
                            startRadius: 0,
                            endRadius: ball.size / 2
                        )
                    )
                    .frame(width: ball.size, height: ball.size)
                    .position(ball.position)
                    .blur(radius: 20)
            }
        }
        .onAppear {
            generateBalls()
            startAnimation()
        }
    }
    
    private func generateBalls() {
        let colors = [AppColors.lightBlue, AppColors.primaryBlue, AppColors.accentPurple]
        
        for i in 0..<8 {
            let ball = MovingBall(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 80...200),
                color: colors[i % colors.count],
                velocity: CGVector(
                    dx: CGFloat.random(in: -0.5...0.5),
                    dy: CGFloat.random(in: -0.5...0.5)
                )
            )
            balls.append(ball)
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            updateBalls()
        }
    }
    
    private func updateBalls() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for i in 0..<balls.count {
            var ball = balls[i]
            
            ball.position.x += ball.velocity.dx
            ball.position.y += ball.velocity.dy
            
            if ball.position.x < 0 || ball.position.x > screenWidth {
                ball.velocity.dx *= -1
            }
            if ball.position.y < 0 || ball.position.y > screenHeight {
                ball.velocity.dy *= -1
            }
            
            balls[i] = ball
        }
    }
}

struct MovingBall: Identifiable {
    let id: UUID
    var position: CGPoint
    let size: CGFloat
    let color: Color
    var velocity: CGVector
}

