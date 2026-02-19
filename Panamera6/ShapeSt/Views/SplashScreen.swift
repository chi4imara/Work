import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ParticlesBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.orange.opacity(0.3), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorTheme.orange, ColorTheme.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(ColorTheme.white)
                        .frame(width: 12, height: 12)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                VStack(spacing: 8) {
                    Text("Loading")
                        .font(.lumierepolis(size: 24, weight: .regular))
                        .foregroundColor(ColorTheme.white)
                    
                    Text("Preparing your style catalog...")
                        .font(.lumierepolis(size: 14))
                        .foregroundColor(ColorTheme.white.opacity(0.7))
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

struct ParticlesBackground: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(ColorTheme.white.opacity(0.1))
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                }
            }
        }
        .onAppear {
            createParticles()
            animateParticles()
        }
    }
    
    private func createParticles() {
        particles = (0..<20).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 2...8),
                opacity: Double.random(in: 0.1...0.3)
            )
        }
    }
    
    private func animateParticles() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in particles.indices {
                particles[i].position.y -= CGFloat.random(in: 0.5...2)
                particles[i].position.x += CGFloat.random(in: -1...1)
                
                if particles[i].position.y < -10 {
                    particles[i].position.y = UIScreen.main.bounds.height + 10
                    particles[i].position.x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                }
            }
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
}
