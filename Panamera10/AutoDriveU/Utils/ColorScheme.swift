import SwiftUI

struct AppColors {
    static let primaryOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let primaryWhite = Color.white
    static let primaryDarkBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let accentRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryOrange, Color(red: 1.0, green: 0.7, blue: 0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = primaryWhite
    static let secondaryText = primaryDarkBlue
    static let cardText = primaryDarkBlue
    
    static func statusColor(for status: ModificationStatus) -> Color {
        switch status {
        case .plan:
            return accentYellow
        case .inProgress:
            return accentPurple
        case .completed:
            return accentGreen
        }
    }
    
    static func categoryColor(for category: ModificationCategory) -> Color {
        switch category {
        case .exterior:
            return accentGreen
        case .technical:
            return accentRed
        case .interior:
            return accentPurple
        case .electrical:
            return accentYellow
        case .other:
            return primaryDarkBlue
        }
    }
}

struct AnimatedBackground: View {
    @State private var animateGradient = false
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: animateGradient ? 
                [AppColors.primaryOrange, Color(red: 1.0, green: 0.7, blue: 0.3), Color(red: 0.9, green: 0.5, blue: 0.1)] :
                [Color(red: 0.9, green: 0.5, blue: 0.1), AppColors.primaryOrange, Color(red: 1.0, green: 0.7, blue: 0.3)],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
                generateParticles()
            }
            
            ForEach(particles) { particle in
                Circle()
                    .fill(AppColors.primaryWhite.opacity(0.6))
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
    
    private func generateParticles() {
        particles = (0..<15).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 8...20),
                duration: Double.random(in: 3...8)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in particles.indices {
                withAnimation(.linear(duration: particles[i].duration).repeatForever(autoreverses: false)) {
                    particles[i].position = CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                }
            }
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let duration: Double
}
