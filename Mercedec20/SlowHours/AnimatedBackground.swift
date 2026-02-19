import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    @State private var animationTimer: Timer?
    
    let bubbleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(bubbles.indices, id: \.self) { index in
                    if index < bubbles.count {
                        Circle()
                            .fill(ColorTheme.lightBlue.opacity(bubbles[index].opacity))
                            .frame(width: bubbles[index].size, height: bubbles[index].size)
                            .position(bubbles[index].position)
                            .animation(.linear(duration: bubbles[index].duration), value: bubbles[index].position)
                    }
                }
            }
        }
        .onAppear {
            setupBubbles()
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func setupBubbles() {
        bubbles = (0..<bubbleCount).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 10...30),
                opacity: Double.random(in: 0.2...0.6),
                duration: Double.random(in: 3...8),
                direction: CGPoint(
                    x: CGFloat.random(in: -1...1),
                    y: CGFloat.random(in: -1...1)
                )
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
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for index in bubbles.indices {
            var bubble = bubbles[index]
            
            bubble.position.x += bubble.direction.x * 0.5
            bubble.position.y += bubble.direction.y * 0.5
            
            if bubble.position.x <= 0 || bubble.position.x >= screenWidth {
                bubble.direction.x *= -1
            }
            if bubble.position.y <= 0 || bubble.position.y >= screenHeight {
                bubble.direction.y *= -1
            }
            
            bubble.position.x = max(0, min(screenWidth, bubble.position.x))
            bubble.position.y = max(0, min(screenHeight, bubble.position.y))
            
            bubbles[index] = bubble
        }
    }
}

struct Bubble {
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var duration: Double
    var direction: CGPoint
}
