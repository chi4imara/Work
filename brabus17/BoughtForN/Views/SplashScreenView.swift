import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var ballPositions: [CGPoint] = []
    
    let ballCount = 15
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<ballCount, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.white.opacity(0.3))
                    .frame(width: CGFloat.random(in: 8...20))
                    .position(ballPositions.indices.contains(index) ? ballPositions[index] : CGPoint(x: 0, y: 0))
                    .animation(
                        Animation.linear(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: false),
                        value: ballPositions
                    )
            }
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(ColorTheme.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(ColorTheme.yellow, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                    
                    Circle()
                        .fill(ColorTheme.white)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                
                Text("Loading...")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorTheme.white)
                    .opacity(opacity)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: opacity
                    )
            }
        }
        .onAppear {
            setupFloatingBalls()
            startAnimations()
        }
    }
    
    private func setupFloatingBalls() {
        ballPositions = (0..<ballCount).map { _ in
            CGPoint(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
            )
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in 0..<ballPositions.count {
                ballPositions[i] = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        
        withAnimation(
            Animation.easeInOut(duration: 1)
                .repeatForever(autoreverses: true)
        ) {
            scale = 1.2
            opacity = 1.0
        }
    }
}
