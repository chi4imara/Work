import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    @State private var animationTimer: Timer?
    
    let bubbleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(bubble.color)
                        .frame(width: bubble.size, height: bubble.size)
                        .position(x: bubble.x, y: bubble.y)
                        .blur(radius: bubble.blur)
                        .animation(
                            Animation.easeInOut(duration: bubble.duration)
                                .repeatForever(autoreverses: true),
                            value: bubble.y
                        )
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
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 20...80),
                color: [AppColors.bubbleBlue1, AppColors.bubbleBlue2, AppColors.bubbleBlue3].randomElement()!,
                duration: Double.random(in: 3...8),
                blur: CGFloat.random(in: 1...3)
            )
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            animateBubbles()
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func animateBubbles() {
        for i in bubbles.indices {
            if Bool.random() {
                bubbles[i].x += CGFloat.random(in: -2...2)
                bubbles[i].y += CGFloat.random(in: -2...2)
                
                bubbles[i].x = max(0, min(UIScreen.main.bounds.width, bubbles[i].x))
                bubbles[i].y = max(0, min(UIScreen.main.bounds.height, bubbles[i].y))
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let color: Color
    let duration: Double
    let blur: CGFloat
}

struct PulsatingBubble: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.3
    
    let color: Color
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                ) {
                    scale = 1.2
                    opacity = 0.1
                }
            }
    }
}

struct FloatingBubbles: View {
    @State private var bubblePositions: [CGPoint] = []
    @State private var animationOffset: CGFloat = 0
    
    let bubbleCount = 8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<bubbleCount, id: \.self) { index in
                    let bubble = getBubbleData(for: index, in: geometry.size)
                    
                    PulsatingBubble(
                        color: bubble.color,
                        size: bubble.size
                    )
                    .position(
                        x: bubble.position.x + sin(animationOffset + Double(index)) * 20,
                        y: bubble.position.y + cos(animationOffset + Double(index) * 0.5) * 15
                    )
                }
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 20)
                    .repeatForever(autoreverses: false)
            ) {
                animationOffset = .pi * 4
            }
        }
    }
    
    private func getBubbleData(for index: Int, in size: CGSize) -> (position: CGPoint, color: Color, size: CGFloat) {
        let colors = [AppColors.bubbleBlue1, AppColors.bubbleBlue2, AppColors.bubbleBlue3]
        let bubbleSize = CGFloat.random(in: 30...60)
        
        let position = CGPoint(
            x: CGFloat.random(in: bubbleSize...(size.width - bubbleSize)),
            y: CGFloat.random(in: bubbleSize...(size.height - bubbleSize))
        )
        
        return (
            position: position,
            color: colors[index % colors.count],
            size: bubbleSize
        )
    }
}

#Preview {
    AnimatedBackground()
}
