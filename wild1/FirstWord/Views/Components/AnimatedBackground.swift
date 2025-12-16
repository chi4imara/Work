import SwiftUI

struct AnimatedBackground: View {
    @State private var particles: [Particle] = []
    @State private var animationTimer: Timer?
    
    let particleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [Color.theme.backgroundStart, Color.theme.backgroundEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ForEach(particles) { particle in
                    Circle()
                        .fill(Color.theme.particleColor)
                        .frame(width: particle.size, height: particle.size)
                        .position(x: particle.x, y: particle.y)
                        .blur(radius: particle.blur)
                }
            }
        }
        .onAppear {
            setupParticles()
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func setupParticles() {
        particles = (0..<particleCount).map { _ in
            Particle(
                x: Double.random(in: 0...UIScreen.main.bounds.width),
                y: Double.random(in: 0...UIScreen.main.bounds.height),
                size: Double.random(in: 20...80),
                speedX: Double.random(in: -0.5...0.5),
                speedY: Double.random(in: -0.5...0.5),
                blur: Double.random(in: 1...3)
            )
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            updateParticles()
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func updateParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for i in particles.indices {
            particles[i].x += particles[i].speedX
            particles[i].y += particles[i].speedY
            
            if particles[i].x < -particles[i].size {
                particles[i].x = screenWidth + particles[i].size
            } else if particles[i].x > screenWidth + particles[i].size {
                particles[i].x = -particles[i].size
            }
            
            if particles[i].y < -particles[i].size {
                particles[i].y = screenHeight + particles[i].size
            } else if particles[i].y > screenHeight + particles[i].size {
                particles[i].y = -particles[i].size
            }
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var x: Double
    var y: Double
    let size: Double
    let speedX: Double
    let speedY: Double
    let blur: Double
}

#Preview {
    AnimatedBackground()
}
