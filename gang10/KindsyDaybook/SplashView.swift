import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseAnimation = false
    @State private var rotationAngle: Double = 0
    @State private var bubbles: [MovingBubble] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles, id: \.id) { bubble in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(.linear(duration: bubble.duration).repeatForever(autoreverses: false), value: bubble.position)
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .opacity(pulseAnimation ? 0.5 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                    
                    Circle()
                        .stroke(AppColors.yellow, lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotationAngle)
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(AppColors.yellow)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 45))
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: isAnimating)
                    }
                    
                    Circle()
                        .fill(AppColors.white)
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            generateBubbles()
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        pulseAnimation = true
        rotationAngle = 360
    }
    
    private func generateBubbles() {
        bubbles = (0..<15).map { _ in
            MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 20...60),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                ),
                duration: Double.random(in: 8...15)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            for i in bubbles.indices {
                bubbles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: -100
                )
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            let newBubble = MovingBubble(
                id: UUID(),
                size: CGFloat.random(in: 20...60),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 100
                ),
                duration: Double.random(in: 8...15)
            )
            
            bubbles.append(newBubble)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let index = bubbles.firstIndex(where: { $0.id == newBubble.id }) {
                    bubbles[index].position = CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: -100
                    )
                }
            }
            
            if bubbles.count > 20 {
                bubbles.removeFirst()
            }
        }
    }
}

struct MovingBubble {
    let id: UUID
    let size: CGFloat
    var position: CGPoint
    let duration: Double
}

#Preview {
    SplashView()
}

