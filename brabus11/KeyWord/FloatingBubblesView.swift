import SwiftUI

struct FloatingBubblesView: View {
    @State private var bubbles: [BubbleData] = []
    
    var body: some View {
        ZStack {
            ForEach(bubbles, id: \.id) { bubble in
                Circle()
                    .fill(bubble.color)
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
            generateBubbles()
            animateBubbles()
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<20).map { _ in
            BubbleData(
                id: UUID(),
                position: CGPoint(
                    x: CGFloat.random(in: 0...400),
                    y: CGFloat.random(in: 800...1000)
                ),
                size: CGFloat.random(in: 15...35),
                color: ColorManager.bubbleColors.randomElement() ?? ColorManager.primaryBlue.opacity(0.3),
                duration: Double.random(in: 10...20)
            )
        }
    }
    
    private func animateBubbles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for index in bubbles.indices {
                bubbles[index].position = CGPoint(
                    x: CGFloat.random(in: 50...350),
                    y: CGFloat.random(in: -100...900)
                )
            }
        }
    }
}

struct BubbleData {
    let id: UUID
    var position: CGPoint
    let size: CGFloat
    let color: Color
    let duration: Double
}
