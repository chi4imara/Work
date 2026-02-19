import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let secondaryBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, secondaryBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let buttonBackground = accentYellow
    static let buttonText = Color.black
    
    static let particleColor = Color.white.opacity(0.6)
}

struct GradientBackground: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            FloatingParticles()
        }
    }
}

struct FloatingParticles: View {
    @State private var particles: [ParticleData] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(AppColors.particleColor)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .animation(
                            Animation.linear(duration: particle.duration)
                                .repeatForever(autoreverses: false),
                            value: particle.position
                        )
                }
            }
        }
        .onAppear {
            generateParticles()
        }
    }
    
    private func generateParticles() {
        particles = (0..<20).map { _ in
            ParticleData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in particles.indices {
                particles[i].startAnimation()
            }
        }
    }
}

struct ParticleData: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var duration: Double
    private var targetPosition: CGPoint
    
    init() {
        self.size = CGFloat.random(in: 4...12)
        self.duration = Double.random(in: 10...20)
        self.position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
        self.targetPosition = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
    }
    
    mutating func startAnimation() {
        position = targetPosition
        
        targetPosition = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
    }
}
