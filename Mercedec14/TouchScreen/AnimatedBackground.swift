import SwiftUI

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    @State private var animationTimer: Timer?
    
    let bubbleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    ColorTheme.bubbleBlue.opacity(0.8),
                                    ColorTheme.bubbleBlue.opacity(0.3),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: bubble.size / 2
                            )
                        )
                        .frame(width: bubble.size, height: bubble.size)
                        .position(x: bubble.x, y: bubble.y)
                        .scaleEffect(bubble.scale)
                        .opacity(bubble.opacity)
                        .animation(
                            .easeInOut(duration: bubble.animationDuration)
                            .repeatForever(autoreverses: true),
                            value: bubble.scale
                        )
                }
            }
        }
        .onAppear {
            setupBubbles()
        }
    }
    
    private func setupBubbles() {
        bubbles = (0..<bubbleCount).map { _ in
            Bubble(
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: 0...UIScreen.main.bounds.height),
                size: Double.random(in: 20...80),
                scale: Double.random(in: 0.5...1.0),
                opacity: Double.random(in: 0.3...0.7),
                animationDuration: Double.random(in: 2.0...5.0)
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
        for i in bubbles.indices {
            bubbles[i].x += bubbles[i].velocityX
            bubbles[i].y += bubbles[i].velocityY
            
            if bubbles[i].x <= 0 || bubbles[i].x >= UIScreen.main.bounds.width {
                bubbles[i].velocityX *= -1
            }
            if bubbles[i].y <= 0 || bubbles[i].y >= UIScreen.main.bounds.height {
                bubbles[i].velocityY *= -1
            }
            
            bubbles[i].x = max(0, min(UIScreen.main.bounds.width, bubbles[i].x))
            bubbles[i].y = max(0, min(UIScreen.main.bounds.height, bubbles[i].y))
            
            withAnimation(.easeInOut(duration: bubbles[i].animationDuration).repeatForever(autoreverses: true)) {
                bubbles[i].scale = bubbles[i].scale == 1.0 ? 0.6 : 1.0
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    let size: Double
    var scale: Double
    let opacity: Double
    let animationDuration: Double
    var velocityX: Double = Double.random(in: -0.5...0.5)
    var velocityY: Double = Double.random(in: -0.5...0.5)
}

struct FloatingParticles: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(ColorTheme.bubbleBlue)
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .opacity(particle.opacity)
                        .scaleEffect(particle.scale)
                }
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        particles = (0..<8).map { _ in
            Particle(
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: 0...UIScreen.main.bounds.height),
                size: Double.random(in: 4...12),
                opacity: Double.random(in: 0.2...0.6),
                scale: Double.random(in: 0.5...1.0)
            )
        }
    }
    
    private func animateParticles() {
        for i in particles.indices {
            withAnimation(
                .linear(duration: Double.random(in: 15...25))
                .repeatForever(autoreverses: false)
            ) {
                particles[i].y -= UIScreen.main.bounds.height + 100
            }
            
            withAnimation(
                .easeInOut(duration: Double.random(in: 2...4))
                .repeatForever(autoreverses: true)
            ) {
                particles[i].scale = particles[i].scale == 1.0 ? 0.3 : 1.0
            }
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    let size: Double
    let opacity: Double
    var scale: Double
}
