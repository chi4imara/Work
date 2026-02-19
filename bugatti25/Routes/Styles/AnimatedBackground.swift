import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    Color.primaryBlue.opacity(0.1),
                    Color.white
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(Color.primaryBlue.opacity(0.3))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(
                        Animation.linear(duration: bubble.duration)
                            .repeatForever(autoreverses: false),
                        value: bubble.position
                    )
            }
        }
        .onAppear {
            createBubbles()
        }
    }
    
    private func createBubbles() {
        bubbles = (0..<8).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 50
                ),
                size: CGFloat.random(in: 20...80),
                duration: Double.random(in: 8...15)
            )
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for index in bubbles.indices {
                bubbles[index].position.y -= CGFloat.random(in: 0.5...2)
                bubbles[index].position.x += CGFloat.random(in: -1...1)
                
                if bubbles[index].position.y < -50 {
                    bubbles[index].position.y = UIScreen.main.bounds.height + 50
                    bubbles[index].position.x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                }
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let duration: Double
}
