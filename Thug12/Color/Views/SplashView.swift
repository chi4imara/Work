import SwiftUI

struct SplashView: View {
    @State private var animationPhase = 0
    @State private var yellowBalls: [YellowBall] = []
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(yellowBalls) { ball in
                Circle()
                    .fill(AppColors.accentYellow.opacity(0.7))
                    .frame(width: ball.size, height: ball.size)
                    .position(ball.position)
                    .animation(.easeInOut(duration: ball.duration).repeatForever(autoreverses: true), value: ball.position)
            }
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryOrange.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseScale)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(AppColors.primaryOrange, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotationAngle)
                    
                    ZStack {
                        ForEach(0..<8, id: \.self) { index in
                            let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink, .gray]
                            Circle()
                                .fill(colors[index])
                                .frame(width: 8, height: 8)
                                .offset(y: -25)
                                .rotationEffect(.degrees(Double(index) * 45 + rotationAngle * 0.5))
                        }
                    }
                    .animation(.linear(duration: 4).repeatForever(autoreverses: false), value: rotationAngle)
                }
                
                Spacer()
                
                VStack(spacing: AppSpacing.sm) {
                    Text("Loading...")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                        .opacity(animationPhase > 0 ? 1 : 0)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(AppColors.primaryOrange)
                                .frame(width: 8, height: 8)
                                .scaleEffect(animationPhase == index + 1 ? 1.5 : 1.0)
                                .animation(.easeInOut(duration: 0.5), value: animationPhase)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            setupAnimations()
        }
    }
    
    private func setupAnimations() {
        yellowBalls = createYellowBalls()
        
        pulseScale = 1.3
        
        rotationAngle = 360
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            animationPhase = (animationPhase + 1) % 4
        }
    }
    
    private func createYellowBalls() -> [YellowBall] {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        var balls: [YellowBall] = []
        
        for i in 0..<8 {
            let ball = YellowBall(
                id: i,
                position: CGPoint(
                    x: CGFloat.random(in: 20...(screenWidth - 20)),
                    y: CGFloat.random(in: 100...(screenHeight - 100))
                ),
                size: CGFloat.random(in: 15...30),
                duration: Double.random(in: 2...4)
            )
            balls.append(ball)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in 0..<balls.count {
                balls[i].position = CGPoint(
                    x: CGFloat.random(in: 20...(screenWidth - 20)),
                    y: CGFloat.random(in: 100...(screenHeight - 100))
                )
            }
            yellowBalls = balls
        }
        
        return balls
    }
}

struct YellowBall: Identifiable {
    let id: Int
    var position: CGPoint
    let size: CGFloat
    let duration: Double
}

#Preview {
    SplashView()
}
