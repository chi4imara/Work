import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        ColorTheme.backgroundWhite,
                        Color(red: 0.95, green: 0.97, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(ColorTheme.bubbleBlue.opacity(0.3))
                        .frame(width: bubble.size, height: bubble.size)
                        .position(bubble.position)
                        .animation(
                            Animation.linear(duration: bubble.duration)
                                .repeatForever(autoreverses: false),
                            value: bubble.position
                        )
                }
            }
        }
        .onAppear {
            createBubbles()
        }
    }
    
    private func createBubbles() {
        bubbles = (0..<15).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 10...30),
                duration: Double.random(in: 8...15)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            animateBubbles()
        }
    }
    
    private func animateBubbles() {
        for index in bubbles.indices {
            bubbles[index].position = CGPoint(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            animateBubbles()
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let duration: Double
}
