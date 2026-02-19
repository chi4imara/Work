import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var animationOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            AppGradients.primaryBackground
                .ignoresSafeArea()
            
            ForEach(particles) { particle in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .animation(.linear(duration: particle.duration).repeatForever(autoreverses: false), value: particle.position)
            }
            
            VStack(spacing: AppSpacing.xl) {
                ZStack {
                    Circle()
                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseScale)
                    
                    ForEach(0..<8) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(AppColors.accentYellow)
                            .frame(width: 4, height: 20)
                            .offset(y: -40)
                            .rotationEffect(.degrees(Double(index) * 45 + rotationAngle))
                            .opacity(Double(index) / 8.0 + 0.3)
                    }
                    .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: rotationAngle)
                    
                    Circle()
                        .fill(AppColors.primaryText)
                        .frame(width: 12, height: 12)
                        .scaleEffect(1.0 + sin(animationOffset) * 0.3)
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animationOffset)
                }
                
                Text("Loading...")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.primaryText)
                    .opacity(0.8)
                    .scaleEffect(1.0 + sin(animationOffset * 1.5) * 0.1)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animationOffset)
            }
        }
        .onAppear {
            startAnimations()
            generateParticles()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
        
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            animationOffset = 1.0
        }
    }
    
    private func generateParticles() {
        particles = (0..<15).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                size: CGFloat.random(in: 4...12),
                duration: Double.random(in: 3...8)
            )
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in particles.indices {
                withAnimation(.linear(duration: particles[i].duration).repeatForever(autoreverses: false)) {
                    particles[i].position = CGPoint(
                        x: CGFloat.random(in: -50...UIScreen.main.bounds.width + 50),
                        y: CGFloat.random(in: -50...UIScreen.main.bounds.height + 50)
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
