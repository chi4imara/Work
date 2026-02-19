import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(DesignConstants.Colors.primaryYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    DesignConstants.Colors.primaryYellow,
                                    DesignConstants.Colors.white,
                                    DesignConstants.Colors.primaryYellow
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2).repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(DesignConstants.Colors.white)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 60 + rotationAngle * 0.5))
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.8)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                value: isAnimating
                            )
                    }
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    DesignConstants.Colors.primaryYellow,
                                    DesignConstants.Colors.primaryYellow.opacity(0.3)
                                ]),
                                center: .center,
                                startRadius: 2,
                                endRadius: 15
                            )
                        )
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        opacity = 1.0
                        scale = 1.0
                    }
                    
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                    
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                        pulseScale = 1.2
                    }
                    
                    isAnimating = true
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct AnimatedBackgroundView: View {
    @State private var animateGradient = false
    @State private var bubbles: [BubbleData] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    DesignConstants.Colors.gradientStart,
                    DesignConstants.Colors.gradientEnd
                ]),
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .animation(
                Animation.easeInOut(duration: 3).repeatForever(autoreverses: true),
                value: animateGradient
            )
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(DesignConstants.Colors.white.opacity(bubble.opacity))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(
                        Animation.linear(duration: bubble.duration).repeatForever(autoreverses: false),
                        value: bubble.position
                    )
            }
        }
        .onAppear {
            animateGradient = false
            generateBubbles()
            animateBubbles()
        }
        .ignoresSafeArea()
    }
    
    private func generateBubbles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        bubbles = (0..<8).map { _ in
            BubbleData(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: screenHeight + 50
                ),
                size: CGFloat.random(in: 10...30),
                opacity: Double.random(in: 0.1...0.3),
                duration: Double.random(in: 8...15)
            )
        }
    }
    
    private func animateBubbles() {
        let screenWidth = UIScreen.main.bounds.width
        
        for index in bubbles.indices {
            let randomX = CGFloat.random(in: 0...screenWidth)
            let targetPosition = CGPoint(x: randomX, y: -50)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...2)) {
                withAnimation(.linear(duration: bubbles[index].duration)) {
                    bubbles[index].position = targetPosition
                }
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            let screenHeight = UIScreen.main.bounds.height
            
            let newBubbles = (0..<3).map { _ in
                BubbleData(
                    position: CGPoint(
                        x: CGFloat.random(in: 0...screenWidth),
                        y: screenHeight + 50
                    ),
                    size: CGFloat.random(in: 10...30),
                    opacity: Double.random(in: 0.1...0.3),
                    duration: Double.random(in: 8...15)
                )
            }
            
            bubbles.append(contentsOf: newBubbles)
            
            for index in (bubbles.count - newBubbles.count)..<bubbles.count {
                let randomX = CGFloat.random(in: 0...screenWidth)
                let targetPosition = CGPoint(x: randomX, y: -50)
                
                withAnimation(.linear(duration: bubbles[index].duration)) {
                    bubbles[index].position = targetPosition
                }
            }
            
            bubbles.removeAll { $0.position.y < -100 }
        }
    }
}

struct BubbleData: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let duration: Double
}

#Preview {
    SplashScreenView()
}
