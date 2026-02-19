import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [BubbleData] = []
    private let bubbleCount = 15
    
    var body: some View {
        ZStack {
            AppColors.backgroundWhite
                .ignoresSafeArea()
            
            ForEach(bubbles, id: \.id) { bubble in
                Circle()
                    .fill(bubble.color.opacity(0.3))
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
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        bubbles = (0..<bubbleCount).map { _ in
            BubbleData(
                id: UUID(),
                x: CGFloat.random(in: 0...screenWidth),
                y: screenHeight + 50,
                size: CGFloat.random(in: 20...80),
                color: AppColors.bubbleColors.randomElement() ?? AppColors.primaryBlue,
                duration: Double.random(in: 8...15)
            )
        }
    }
    
    private func startBubbleAnimation() {
        let screenHeight = UIScreen.main.bounds.height
        
        for i in 0..<bubbles.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                bubbles[i].y = -100
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            resetBubbles()
        }
    }
    
    private func resetBubbles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for i in 0..<bubbles.count {
            bubbles[i].x = CGFloat.random(in: 0...screenWidth)
            bubbles[i].y = screenHeight + 50
            bubbles[i].size = CGFloat.random(in: 20...80)
            bubbles[i].color = AppColors.bubbleColors.randomElement() ?? AppColors.primaryBlue
            bubbles[i].duration = Double.random(in: 8...15)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                bubbles[i].y = -100
            }
        }
    }
}

struct BubbleData {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var color: Color
    var duration: Double
}
