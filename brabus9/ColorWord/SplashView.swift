import SwiftUI

struct SplashView: View {
    @State private var waveOffset: CGFloat = 0
    @State private var particleRotation: Double = 0
    @State private var morphingShape: CGFloat = 0
    @State private var glowIntensity: Double = 0.5
    @State private var floatingOffset: CGFloat = 0
    @State private var scalePulse: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                Spacer()
                
                ZStack {
                    ForEach(0..<8, id: \.self) { index in
                        MorphingShape(index: index)
                            .offset(x: floatingOffset * cos(Double(index) * .pi / 4),
                                   y: floatingOffset * sin(Double(index) * .pi / 4))
                            .rotationEffect(.degrees(particleRotation + Double(index) * 45))
                            .scaleEffect(scalePulse)
                    }
                    
                    WaveLoader(offset: waveOffset)
                        .frame(width: 150, height: 150)
                    
                    GlowingOrb(intensity: glowIntensity)
                        .frame(width: 60, height: 60)
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            LoadingDot(delay: Double(index) * 0.2)
                        }
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            startComplexAnimations()
        }
    }
    
    private func startComplexAnimations() {
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            waveOffset = 100
            morphingShape = 1.0
            floatingOffset = 30
            scalePulse = 1.15
        }
        
        withAnimation(
            Animation.linear(duration: 4.0)
                .repeatForever(autoreverses: false)
        ) {
            particleRotation = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            glowIntensity = 1.0
        }
    }
}

struct MorphingShape: View {
    let index: Int
    @State private var morph: CGFloat = 0
    
    var body: some View {
        Group {
            if index % 2 == 0 {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppColors.accent.opacity(0.6),
                                AppColors.softPink.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 20, height: 20)
                    .rotationEffect(.degrees(morph * 45))
            } else {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                AppColors.lightGreen.opacity(0.6),
                                AppColors.lavender.opacity(0.3)
                            ],
                            center: .center,
                            startRadius: 2,
                            endRadius: 10
                        )
                    )
                    .frame(width: 16, height: 16)
            }
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                    .delay(Double(index) * 0.2)
            ) {
                morph = 1.0
            }
        }
    }
}

struct WaveLoader: View {
    let offset: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .trim(from: 0, to: 0.6)
                    .stroke(
                        AngularGradient(
                            colors: [
                                AppColors.accent,
                                AppColors.accentSecondary,
                                AppColors.softPink,
                                AppColors.lightGreen,
                                AppColors.accent
                            ],
                            center: .center,
                            angle: .degrees(offset + Double(index) * 120)
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 120 - CGFloat(index) * 30, height: 120 - CGFloat(index) * 30)
                    .rotationEffect(.degrees(offset + Double(index) * 60))
            }
        }
    }
}

struct GlowingOrb: View {
    let intensity: Double
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            AppColors.accent.opacity(intensity),
                            AppColors.accentSecondary.opacity(intensity * 0.6),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 5,
                        endRadius: 30
                    )
                )
            
            Circle()
                .fill(AppColors.primaryText)
                .frame(width: 12, height: 12)
                .blur(radius: 2)
        }
    }
}

struct LoadingDot: View {
    let delay: Double
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(AppColors.accent)
            .frame(width: 10, height: 10)
            .scaleEffect(isAnimating ? 1.3 : 0.7)
            .opacity(isAnimating ? 1.0 : 0.5)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 0.8)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    SplashView()
}
