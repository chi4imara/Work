import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var bubbles: [BubbleData] = []
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(x: bubble.x, y: bubble.y)
                    .animation(
                        Animation.linear(duration: bubble.duration)
                            .repeatForever(autoreverses: false),
                        value: bubble.y
                    )
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.primaryYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(Color.primaryYellow, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    
                    Circle()
                        .fill(Color.primaryWhite)
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .opacity(isAnimating ? 0.6 : 1.0)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showMainApp = true
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        generateBubbles()
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            animateBubbles()
        }
    }
    
    private func generateBubbles() {
        bubbles = (0..<15).map { _ in
            BubbleData(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: UIScreen.main.bounds.height + 50,
                size: CGFloat.random(in: 20...60),
                duration: Double.random(in: 8...15)
            )
        }
    }
    
    private func animateBubbles() {
        for i in bubbles.indices {
            bubbles[i].y = -100
            
            DispatchQueue.main.asyncAfter(deadline: .now() + bubbles[i].duration) {
                if i < bubbles.count {
                    bubbles[i].x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                    bubbles[i].y = UIScreen.main.bounds.height + 50
                }
            }
        }
    }
}

struct BubbleData: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    let duration: Double
}

#Preview {
    SplashView()
}
