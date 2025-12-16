import SwiftUI

struct AnimatedBackground: View {
    @State private var animationOffset: CGSize = .zero
    @State private var bubbles: [Bubble] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(AppColors.lightBlue.opacity(bubble.opacity))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
            }
        }
        .onAppear {
            generateBubbles()
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<15).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 20...80),
                opacity: Double.random(in: 0.1...0.4),
                duration: Double.random(in: 8...15)
            )
        }
    }
    
    private func startBubbleAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in bubbles.indices {
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                
                bubbles[i].position.x += bubbles[i].velocity.x
                bubbles[i].position.y += bubbles[i].velocity.y
                
                if bubbles[i].position.x <= 0 || bubbles[i].position.x >= screenWidth {
                    bubbles[i].velocity.x *= -1
                }
                if bubbles[i].position.y <= 0 || bubbles[i].position.y >= screenHeight {
                    bubbles[i].velocity.y *= -1
                }
                
                bubbles[i].position.x = max(0, min(screenWidth, bubbles[i].position.x))
                bubbles[i].position.y = max(0, min(screenHeight, bubbles[i].position.y))
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let duration: Double
    var velocity: CGPoint = CGPoint(
        x: Double.random(in: -1...1),
        y: Double.random(in: -1...1)
    )
}

#Preview {
    AnimatedBackground()
}
