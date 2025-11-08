import SwiftUI

struct AnimatedBackground: View {
    @State private var animateGradient = false
    @State private var bubbles: [BubbleData] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: animateGradient ? 
                    [AppColors.backgroundWhite, AppColors.purpleGradientEnd, AppColors.purpleGradientStart] :
                    [AppColors.backgroundWhite, AppColors.purpleGradientStart, AppColors.purpleGradientEnd],
                startPoint: animateGradient ? .topTrailing : .topLeading,
                endPoint: animateGradient ? .bottomLeading : .bottomTrailing
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
                generateBubbles()
            }
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [bubble.color.opacity(0.3), bubble.color.opacity(0.1)],
                            center: .center,
                            startRadius: 0,
                            endRadius: bubble.size / 2
                        )
                    )
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(
                        .linear(duration: bubble.duration)
                        .repeatForever(autoreverses: false),
                        value: bubble.position
                    )
            }
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<8).map { _ in
            BubbleData(
                size: Double.random(in: 40...120),
                color: [AppColors.lightPurple, AppColors.accentYellow.opacity(0.6), AppColors.accentGreen.opacity(0.4)].randomElement() ?? AppColors.lightPurple,
                startPosition: CGPoint(
                    x: Double.random(in: -50...UIScreen.main.bounds.width + 50),
                    y: UIScreen.main.bounds.height + 100
                ),
                endPosition: CGPoint(
                    x: Double.random(in: -50...UIScreen.main.bounds.width + 50),
                    y: -100
                ),
                duration: Double.random(in: 15...25)
            )
        }
        
        for i in bubbles.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...5)) {
                bubbles[i].position = bubbles[i].endPosition
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
            generateBubbles()
        }
    }
}

struct BubbleData: Identifiable {
    let id: UUID
    let size: Double
    let color: Color
    let startPosition: CGPoint
    let endPosition: CGPoint
    let duration: Double
    var position: CGPoint
    
    init(size: Double, color: Color, startPosition: CGPoint, endPosition: CGPoint, duration: Double) {
        self.id = UUID()
        self.size = size
        self.color = color
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.duration = duration
        self.position = startPosition
    }
}

#Preview {
    AnimatedBackground()
}
