import SwiftUI

struct AnimatedBackground: View {
    @State private var animationOffset: CGSize = .zero
    @State private var bubbles: [BubbleData] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    AppColors.primary.opacity(0.3),
                                    AppColors.primary.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: bubble.size / 2
                            )
                        )
                        .frame(width: bubble.size, height: bubble.size)
                        .position(bubble.position)
                }
            }
        }
        .onAppear {
            setupBubbles()
        }
    }
    
    private func setupBubbles() {
        bubbles = (0..<15).map { _ in
            BubbleData(
                size: CGFloat.random(in: 20...80),
                position: CGPoint(
                    x: CGFloat.random(in: -100...UIScreen.main.bounds.width + 100),
                    y: CGFloat.random(in: -100...UIScreen.main.bounds.height + 100)
                ),
                duration: Double.random(in: 8...15)
            )
        }
    }
    
    private func startBubbleAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in bubbles.indices {
                let angle = Double.random(in: 0...2 * .pi)
                let speed: CGFloat = 0.5
                
                bubbles[i].position.x += cos(angle) * speed
                bubbles[i].position.y += sin(angle) * speed
                
                let screenBounds = UIScreen.main.bounds
                if bubbles[i].position.x < -100 || bubbles[i].position.x > screenBounds.width + 100 ||
                   bubbles[i].position.y < -100 || bubbles[i].position.y > screenBounds.height + 100 {
                    
                    bubbles[i].position = CGPoint(
                        x: CGFloat.random(in: -50...screenBounds.width + 50),
                        y: CGFloat.random(in: -50...screenBounds.height + 50)
                    )
                }
            }
        }
    }
}

struct BubbleData: Identifiable {
    let id = UUID()
    var size: CGFloat
    var position: CGPoint
    let duration: Double
}

#Preview {
    AnimatedBackground()
}
