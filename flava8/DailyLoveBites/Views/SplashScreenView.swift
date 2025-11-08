import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var animationAmount = 1.0
    @State private var pulseAmount = 1.0
    @State private var rotationAmount = 0.0
    @State private var floatingOffset = 0.0
    @State private var particleAnimations: [Bool] = Array(repeating: false, count: 8)
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                FloatingParticle(
                    delay: Double(index) * 0.2,
                    isAnimating: particleAnimations[index]
                )
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAmount)
                        .opacity(2 - pulseAmount)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [Color.primaryPurple, Color.accentOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAmount))
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.accentPink.opacity(0.8), Color.primaryPurple.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(animationAmount)
                        .shadow(color: Color.primaryPurple.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animationAmount * 1.5)
                }
                .offset(y: floatingOffset)
                
                VStack(spacing: 8) {
                    Text("Loading your recipes...")
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(animationAmount)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.white.opacity(0.7))
                                .frame(width: 6, height: 6)
                                .scaleEffect(particleAnimations[index] ? 1.2 : 0.8)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: particleAnimations[index]
                                )
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseAmount = 1.3
        }
        
        withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAmount = 360
        }
        
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            animationAmount = 1.2
        }
        
        withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            floatingOffset = -10
        }
        
        for i in 0..<particleAnimations.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                particleAnimations[i] = true
            }
        }
    }
}

struct FloatingParticle: View {
    let delay: Double
    @State private var offset = CGSize.zero
    @State private var opacity = 0.0
    let isAnimating: Bool
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.6))
            .frame(width: CGFloat.random(in: 4...8), height: CGFloat.random(in: 4...8))
            .offset(offset)
            .opacity(opacity)
            .onAppear {
                startFloating()
            }
    }
    
    private func startFloating() {
        let randomX = CGFloat.random(in: -150...150)
        let randomY = CGFloat.random(in: -200...200)
        
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 3...6))
                .repeatForever(autoreverses: true)
                .delay(delay)
        ) {
            offset = CGSize(width: randomX, height: randomY)
        }
        
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
                .delay(delay)
        ) {
            opacity = Double.random(in: 0.3...0.8)
        }
    }
}

