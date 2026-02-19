import SwiftUI

struct SplashScreenView: View {
    @State private var animationProgress: CGFloat = 0
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(particles) { particle in
                Circle()
                    .fill(ColorTheme.primaryWhite.opacity(0.6))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .animation(
                        Animation.linear(duration: particle.duration)
                            .repeatForever(autoreverses: false),
                        value: particle.position
                    )
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.primaryWhite.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: animationProgress)
                        .stroke(
                            ColorTheme.primaryWhite,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: animationProgress
                        )
                    
                    Circle()
                        .fill(ColorTheme.primaryPurple.opacity(0.8))
                        .frame(width: 60, height: 60)
                        .scaleEffect(1.0 + sin(animationProgress * .pi * 4) * 0.2)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: animationProgress
                        )
                    
                    Circle()
                        .fill(ColorTheme.primaryWhite)
                        .frame(width: 12, height: 12)
                        .opacity(0.9)
                }
                
                Text("Your SPA guide near you")
                    .font(.playfairMedium(size: 18))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animationProgress > 0.3 ? 1.0 : 0.0)
                    .animation(.easeIn(duration: 1.0), value: animationProgress)
                
                Text("Find the best SPA salons nearby, book treatments, and track your personal care routine.")
                    .font(.playfairRegular(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .opacity(animationProgress > 0.6 ? 1.0 : 0.0)
                    .animation(.easeIn(duration: 1.0).delay(0.5), value: animationProgress)
                
                Spacer()
            }
        }
        .onAppear {
            setupParticles()
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                withAnimation(.easeInOut(duration: 0.8)) {
                }
            }
        }
    }
    
    private func setupParticles() {
        particles = (0..<20).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 4...12),
                duration: Double.random(in: 8...15)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in particles.indices {
                particles[i].position = CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                )
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 0.1)) {
            animationProgress = 1.0
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let duration: Double
}
