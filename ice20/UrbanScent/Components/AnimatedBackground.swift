import SwiftUI

struct AnimatedBackground: View {
    @State private var animateGradient = false
    @State private var bubbles: [Bubble] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.appBackgroundStart,
                    Color.appBackgroundEnd,
                    Color.appPrimaryBlue
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(Color.white.opacity(bubble.opacity))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(x: bubble.x, y: bubble.y)
                    .animation(
                        .linear(duration: bubble.duration)
                        .repeatForever(autoreverses: false),
                        value: bubble.y
                    )
            }
        }
        .onAppear {
            createBubbles()
        }
    }
    
    private func createBubbles() {
        bubbles = (0..<15).map { _ in
            Bubble(
                id: UUID(),
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: UIScreen.main.bounds.height + 100,
                size: CGFloat.random(in: 10...40),
                opacity: Double.random(in: 0.1...0.3),
                duration: Double.random(in: 8...15)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in bubbles.indices {
                withAnimation(.linear(duration: bubbles[i].duration).repeatForever(autoreverses: false)) {
                    bubbles[i].y = -100
                }
            }
        }
    }
}

struct Bubble: Identifiable {
    let id: UUID
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let opacity: Double
    let duration: Double
}

#Preview {
    AnimatedBackground()
}
