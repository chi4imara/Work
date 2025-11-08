import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @Binding var showMainView: Bool
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 60) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.yellow.opacity(0.8), AppColors.yellow.opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .stroke(
                            AppColors.teal.opacity(0.6),
                            style: StrokeStyle(lineWidth: 2, dash: [10, 5])
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 4.0)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ForEach(0..<6) { index in
                        Circle()
                            .fill(AppColors.yellow)
                            .frame(width: 6, height: 6)
                            .offset(y: -35)
                            .rotationEffect(.degrees(Double(index) * 60 + rotationAngle * 0.5))
                            .animation(
                                Animation.linear(duration: 3.0)
                                    .repeatForever(autoreverses: false),
                                value: rotationAngle
                            )
                    }
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [AppColors.yellow.opacity(0.3), AppColors.yellow.opacity(0.1)]),
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(AppColors.yellow)
                            .scaleEffect(isAnimating ? 1.1 : 0.9)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                }
                
                VStack(spacing: 16) {
                    LoadingDots()
                    
                    Text("Loading your dreams...")
                        .font(AppFonts.medium(16))
                        .foregroundColor(AppColors.primaryText)
                        .opacity(isAnimating ? 1.0 : 0.6)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                Spacer()
                Spacer()
            }
            
            FloatingParticles()
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showMainView = true
                }
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        pulseScale = 1.2
        rotationAngle = 360
    }
}

struct LoadingDots: View {
    @State private var animatingDots = [false, false, false]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(AppColors.yellow)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animatingDots[index] ? 1.3 : 0.7)
                    .opacity(animatingDots[index] ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: animatingDots[index]
                    )
            }
        }
        .onAppear {
            for i in 0..<3 {
                animatingDots[i] = true
            }
        }
    }
}

struct FloatingParticles: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var position: CGPoint
        var velocity: CGVector
        var scale: CGFloat
        var opacity: Double
        var color: Color
        var icon: String
    }
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Image(systemName: particle.icon)
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(particle.color)
                    .scaleEffect(particle.scale)
                    .opacity(particle.opacity)
                    .position(particle.position)
            }
        }
        .onAppear {
            createParticles()
            startParticleAnimation()
        }
    }
    
    private func createParticles() {
        let icons = ["star.fill", "sparkles", "moon.fill", "cloud.fill"]
        let colors = [AppColors.yellow, AppColors.teal, AppColors.purple, AppColors.green]
        
        for _ in 0..<15 {
            let particle = Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                velocity: CGVector(
                    dx: CGFloat.random(in: -0.5...0.5),
                    dy: CGFloat.random(in: -1.0...1.0)
                ),
                scale: CGFloat.random(in: 0.5...1.0),
                opacity: Double.random(in: 0.3...0.7),
                color: colors.randomElement() ?? AppColors.yellow,
                icon: icons.randomElement() ?? "star.fill"
            )
            particles.append(particle)
        }
    }
    
    private func startParticleAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateParticles()
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].position.x += particles[i].velocity.dx
            particles[i].position.y += particles[i].velocity.dy
            
            if particles[i].position.x < 0 {
                particles[i].position.x = UIScreen.main.bounds.width
            } else if particles[i].position.x > UIScreen.main.bounds.width {
                particles[i].position.x = 0
            }
            
            if particles[i].position.y < 0 {
                particles[i].position.y = UIScreen.main.bounds.height
            } else if particles[i].position.y > UIScreen.main.bounds.height {
                particles[i].position.y = 0
            }
        }
    }
}

