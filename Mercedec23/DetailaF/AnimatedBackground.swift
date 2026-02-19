import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(AppColors.bubbleBlue)
                    .frame(width: bubble.size, height: bubble.size)
                    .position(x: bubble.x, y: bubble.y)
                    .animation(
                        Animation.linear(duration: bubble.duration)
                            .repeatForever(autoreverses: false),
                        value: bubble.y
                    )
            }
        }
        .onAppear {
            generateBubbles()
            startBubbleAnimation()
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<AppConstants.bubbleCount).map { _ in
            Bubble(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: UIScreen.main.bounds.height + 100,
                size: CGFloat.random(in: AppConstants.bubbleMinSize...AppConstants.bubbleMaxSize),
                duration: Double.random(in: 6...12)
            )
        }
    }
    
    private func startBubbleAnimation() {
        for i in 0..<bubbles.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                animateBubble(at: i)
            }
        }
    }
    
    private func animateBubble(at index: Int) {
        guard index < bubbles.count else { return }
        
        bubbles[index].y = -100
        
        DispatchQueue.main.asyncAfter(deadline: .now() + bubbles[index].duration) {
            bubbles[index].y = UIScreen.main.bounds.height + 100
            bubbles[index].x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                animateBubble(at: index)
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let duration: Double
}

#Preview {
    AnimatedBackground()
}
