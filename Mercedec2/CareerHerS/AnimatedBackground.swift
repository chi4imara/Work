import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    @State private var animationTimer: Timer?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.theme.backgroundGradient
                
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.theme.lightBlue.opacity(0.6),
                                    Color.theme.primaryBlue.opacity(0.3),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: bubble.size / 2
                            )
                        )
                        .frame(width: bubble.size, height: bubble.size)
                        .position(x: bubble.x, y: bubble.y)
                        .animation(.linear(duration: bubble.duration), value: bubble.y)
                        .animation(.linear(duration: bubble.duration * 0.8), value: bubble.x)
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
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        bubbles = (0..<15).map { _ in
            Bubble(
                x: Double.random(in: 0...screenWidth),
                y: screenHeight + 100,
                size: Double.random(in: 20...80),
                duration: Double.random(in: 8...15)
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
        
        for i in 0..<bubbles.count {
            bubbles[i].y -= 2
            bubbles[i].x += sin(bubbles[i].y * 0.01) * 0.5
            
            if bubbles[i].y < -100 {
                bubbles[i].y = screenHeight + 100
                bubbles[i].x = Double.random(in: 0...screenWidth)
                bubbles[i].size = Double.random(in: 20...80)
                bubbles[i].duration = Double.random(in: 8...15)
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    var size: Double
    var duration: Double
}

#Preview {
    AnimatedBackground()
}
