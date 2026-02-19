import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: Theme.Spacing.xl) {
                CustomLoader(isAnimating: $isAnimating)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .rotationEffect(.degrees(rotationAngle))
                
                Text("Loading your journey...")
                    .font(Theme.Fonts.playfairMedium(size: 18))
                    .foregroundColor(Theme.Colors.text)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(Theme.Animation.bounce.repeatForever(autoreverses: true)) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(Theme.Animation.slow.repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

struct CustomLoader: View {
    @Binding var isAnimating: Bool
    @State private var currentIndex = 0
    
    private let colors: [Color] = [
        Theme.Colors.bubbleBlue,
        Theme.Colors.bubbleLight,
        Theme.Colors.bubbleDark,
        Theme.Colors.secondary,
        Theme.Colors.accent
    ]
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.Colors.primary.opacity(0.3), lineWidth: 4)
                .frame(width: 80, height: 80)
                .scaleEffect(isAnimating ? 1.2 : 0.8)
                .animation(Theme.Animation.bounce.repeatForever(autoreverses: true), value: isAnimating)
            
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(colors[index])
                    .frame(width: 12, height: 12)
                    .offset(y: -30)
                    .rotationEffect(.degrees(Double(index) * 72))
                    .scaleEffect(currentIndex == index ? 1.5 : 1.0)
                    .animation(Theme.Animation.bounce, value: currentIndex)
            }
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Theme.Colors.secondary, Theme.Colors.accent],
                        center: .center,
                        startRadius: 2,
                        endRadius: 15
                    )
                )
                .frame(width: 20, height: 20)
                .scaleEffect(isAnimating ? 1.3 : 0.7)
                .animation(Theme.Animation.bounce.repeatForever(autoreverses: true), value: isAnimating)
        }
        .onAppear {
            startDotAnimation()
        }
    }
    
    private func startDotAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation(Theme.Animation.quick) {
                currentIndex = (currentIndex + 1) % 5
            }
        }
    }
}

struct AnimatedBackground: View {
    @State private var bubbles: [FloatingBubble] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Theme.Colors.background,
                    Theme.Colors.background.opacity(0.9),
                    Theme.Colors.bubbleLight.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(bubble.color)
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(
                        Animation.linear(duration: bubble.duration)
                            .repeatForever(autoreverses: false),
                        value: bubble.position
                    )
            }
        }
        .onAppear {
            createBubbles()
            animateBubbles()
        }
    }
    
    private func createBubbles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<15 {
            let bubble = FloatingBubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: screenHeight + 50
                ),
                size: CGFloat.random(in: 20...60),
                color: [Theme.Colors.bubbleBlue, Theme.Colors.bubbleLight, Theme.Colors.bubbleDark].randomElement()!,
                duration: Double.random(in: 8...15)
            )
            bubbles.append(bubble)
        }
    }
    
    private func animateBubbles() {
        let screenWidth = UIScreen.main.bounds.width
        
        for index in bubbles.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...2)) {
                bubbles[index].position = CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: -100
                )
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            animateBubbles()
        }
    }
}

struct FloatingBubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let color: Color
    let duration: Double
}

#Preview {
    SplashView()
}
