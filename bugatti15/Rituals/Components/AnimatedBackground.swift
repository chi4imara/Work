import SwiftUI

struct FloatingBubble: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var speed: CGFloat
    var direction: CGFloat
}

struct AnimatedBackground: View {
    @State private var bubbles: [FloatingBubble] = []
    @State private var animationTimer: Timer?
    
    let bubbleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(AppColors.white.opacity(bubble.opacity))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(x: bubble.x, y: bubble.y)
                        .blur(radius: 1)
                }
            }
            .onAppear {
                setupBubbles(in: geometry.size)
                startAnimation()
            }
            .onDisappear {
                stopAnimation()
            }
        }
    }
    
    private func setupBubbles(in size: CGSize) {
        bubbles = (0..<bubbleCount).map { _ in
            FloatingBubble(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height),
                size: CGFloat.random(in: 10...40),
                opacity: Double.random(in: 0.1...0.3),
                speed: CGFloat.random(in: 0.5...2.0),
                direction: CGFloat.random(in: 0...2 * .pi)
            )
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateBubbles()
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func updateBubbles() {
        for i in bubbles.indices {
            bubbles[i].x += cos(bubbles[i].direction) * bubbles[i].speed
            bubbles[i].y += sin(bubbles[i].direction) * bubbles[i].speed
            
            if bubbles[i].x < -50 {
                bubbles[i].x = UIScreen.main.bounds.width + 50
            } else if bubbles[i].x > UIScreen.main.bounds.width + 50 {
                bubbles[i].x = -50
            }
            
            if bubbles[i].y < -50 {
                bubbles[i].y = UIScreen.main.bounds.height + 50
            } else if bubbles[i].y > UIScreen.main.bounds.height + 50 {
                bubbles[i].y = -50
            }
            
            bubbles[i].direction += CGFloat.random(in: -0.1...0.1)
        }
    }
}

struct PulsingCircle: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.7
    
    let color: Color
    let size: CGFloat
    
    init(color: Color = AppColors.white, size: CGFloat = 100) {
        self.color = color
        self.size = size
    }
    
    var body: some View {
        Circle()
            .fill(color.opacity(opacity))
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                ) {
                    scale = 1.2
                    opacity = 0.3
                }
            }
    }
}

#Preview {
    AnimatedBackground()
}
