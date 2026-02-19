import SwiftUI

struct AnimatedBackground: View {
    @State private var animatedBalls: [AnimatedBall] = []
    
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
            
            ForEach(animatedBalls.indices, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: animatedBalls[index].size, height: animatedBalls[index].size)
                    .position(animatedBalls[index].position)
                    .animation(
                        Animation.linear(duration: animatedBalls[index].duration)
                            .repeatForever(autoreverses: false),
                        value: animatedBalls[index].position
                    )
            }
        }
        .onAppear {
            setupAnimatedBalls()
        }
    }
    
    private func setupAnimatedBalls() {
        animatedBalls = (0..<15).map { _ in
            AnimatedBall(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 8...20),
                duration: Double.random(in: 3...8)
            )
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for index in animatedBalls.indices {
                withAnimation(.linear(duration: animatedBalls[index].duration)) {
                    animatedBalls[index].position = CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                }
            }
        }
    }
}

struct AnimatedBall {
    var position: CGPoint
    let size: CGFloat
    let duration: Double
}

#Preview {
    AnimatedBackground()
}
