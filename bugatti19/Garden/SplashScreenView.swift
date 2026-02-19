import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.3
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.iconAccent.opacity(0.5), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.iconAccent, AppColors.softYellow, AppColors.iconAccent],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.primaryWhite)
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
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.iconAccent.opacity(0.9))
                            .frame(width: 30, height: 30)
                            .scaleEffect(scale)
                        
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.iconPrimary)
                            .scaleEffect(scale)
                    }
                }
                .scaleEffect(showContent ? 1.0 : 0.8)
                .opacity(showContent ? 1.0 : 0.0)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            showContent = true
        }
        
        withAnimation(.easeInOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = true
        }
    }
}

struct AnimatedBackground: View {
    @State private var moveOffset: CGSize = .zero
    @State private var bubbles: [BubbleData] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(AppColors.primaryWhite.opacity(bubble.opacity))
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
            generateBubbles()
        }
    }
    
    private func generateBubbles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<15 {
            let bubble = BubbleData(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                ),
                size: CGFloat.random(in: 20...60),
                opacity: Double.random(in: 0.1...0.3),
                duration: Double.random(in: 8...15)
            )
            bubbles.append(bubble)
        }
    }
    
    private func startBubbleAnimation() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in 0..<bubbles.count {
                let randomX = CGFloat.random(in: -50...50)
                let randomY = CGFloat.random(in: -50...50)
                
                bubbles[i].position.x += randomX * 0.01
                bubbles[i].position.y += randomY * 0.01
                
                if bubbles[i].position.x > screenWidth + 50 {
                    bubbles[i].position.x = -50
                }
                if bubbles[i].position.x < -50 {
                    bubbles[i].position.x = screenWidth + 50
                }
                if bubbles[i].position.y > screenHeight + 50 {
                    bubbles[i].position.y = -50
                }
                if bubbles[i].position.y < -50 {
                    bubbles[i].position.y = screenHeight + 50
                }
            }
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

