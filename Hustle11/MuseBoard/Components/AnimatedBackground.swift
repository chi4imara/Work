import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                FloatingCircle(
                    delay: Double(index) * 0.5,
                    duration: Double.random(in: 8...15)
                )
            }
        }
    }
}

struct FloatingCircle: View {
    let delay: Double
    let duration: Double
    
    @State private var moveUp = false
    @State private var moveRight = false
    @State private var opacity: Double = 0
    
    private let size = CGFloat.random(in: 8...25)
    private let startX = CGFloat.random(in: -50...400)
    private let startY: CGFloat = 900
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.1))
            .frame(width: size, height: size)
            .position(
                x: moveRight ? startX + CGFloat.random(in: -100...100) : startX,
                y: moveUp ? -50 : startY
            )
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                    opacity = 1
                }
                
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    moveUp = true
                }
                
                withAnimation(
                    .easeInOut(duration: duration * 0.7)
                    .repeatForever(autoreverses: true)
                    .delay(delay + 1)
                ) {
                    moveRight = true
                }
            }
    }
}

struct AnimatedGradientOverlay: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            colors: [
                AppColors.primaryBlue.opacity(animateGradient ? 0.8 : 0.6),
                AppColors.secondaryBlue.opacity(animateGradient ? 0.6 : 0.8),
                AppColors.primaryBlue.opacity(animateGradient ? 0.9 : 0.7)
            ],
            startPoint: animateGradient ? .topTrailing : .topLeading,
            endPoint: animateGradient ? .bottomLeading : .bottomTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                .easeInOut(duration: 8)
                .repeatForever(autoreverses: true)
            ) {
                animateGradient = true
            }
        }
    }
}

struct ParticleSystem: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(Color.white.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .scaleEffect(particle.scale)
            }
        }
        .onAppear {
            createParticles()
            startAnimation()
        }
    }
    
    private func createParticles() {
        particles = (0..<20).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...400),
                    y: CGFloat.random(in: 0...900)
                ),
                size: CGFloat.random(in: 2...8),
                opacity: Double.random(in: 0.1...0.3),
                scale: CGFloat.random(in: 0.5...1.5)
            )
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            updateParticles()
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].update()
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var scale: CGFloat
    
    private var velocity: CGPoint = CGPoint(
        x: CGFloat.random(in: -0.5...0.5),
        y: CGFloat.random(in: -0.5...0.5)
    )
    
    init(position: CGPoint, size: CGFloat, opacity: Double, scale: CGFloat) {
        self.position = position
        self.size = size
        self.opacity = opacity
        self.scale = scale
    }
    
    mutating func update() {
        position.x += velocity.x
        position.y += velocity.y
        
        if position.x < 0 {
            position.x = 400
        } else if position.x > 400 {
            position.x = 0
        }
        
        if position.y < 0 {
            position.y = 900
        } else if position.y > 900 {
            position.y = 0
        }
    }
}
