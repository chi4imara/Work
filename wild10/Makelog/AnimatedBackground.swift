import SwiftUI

struct AnimatedBackground: View {
    @State private var particles: [Particle] = []
    @State private var animationTimer: Timer?
    
    let particleCount = 15
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppColors.backgroundGradientStart,
                        AppColors.backgroundGradientEnd
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ForEach(particles.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(particles[index].opacity))
                        .frame(width: particles[index].size, height: particles[index].size)
                        .position(particles[index].position)
                        .blur(radius: particles[index].blur)
                }
            }
        }
        .onAppear {
            setupParticles()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    private func setupParticles() {
        particles = (0..<particleCount).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 10...40),
                opacity: Double.random(in: 0.1...0.4),
                blur: CGFloat.random(in: 0...3),
                duration: Double.random(in: 8...15)
            )
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            updateParticles()
        }
    }
    
    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func updateParticles() {
        for index in particles.indices {
            particles[index].position.x += particles[index].velocity.x
            particles[index].position.y += particles[index].velocity.y
            
            if particles[index].position.x > UIScreen.main.bounds.width + 50 {
                particles[index].position.x = -50
            }
            if particles[index].position.x < -50 {
                particles[index].position.x = UIScreen.main.bounds.width + 50
            }
            if particles[index].position.y > UIScreen.main.bounds.height + 50 {
                particles[index].position.y = -50
            }
            if particles[index].position.y < -50 {
                particles[index].position.y = UIScreen.main.bounds.height + 50
            }
        }
    }
}

struct Particle {
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let blur: CGFloat
    let duration: Double
    let velocity: CGPoint
    
    init(position: CGPoint, size: CGFloat, opacity: Double, blur: CGFloat, duration: Double) {
        self.position = position
        self.size = size
        self.opacity = opacity
        self.blur = blur
        self.duration = duration
        self.velocity = CGPoint(
            x: CGFloat.random(in: -0.5...0.5),
            y: CGFloat.random(in: -0.5...0.5)
        )
    }
}

#Preview {
    AnimatedBackground()
}
