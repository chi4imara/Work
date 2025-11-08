import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var circleScale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primary.opacity(0.3), AppColors.secondary.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(0.7)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            AppColors.primaryGradient,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.accentGradient)
                        .frame(width: 40, height: 40)
                        .scaleEffect(circleScale)
                    
                    Circle()
                        .fill(AppColors.onPrimary)
                        .frame(width: 8, height: 8)
                        .opacity(opacity)
                }
                
                Text("Loading...")
                    .font(AppFonts.medium(18))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onComplete()
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.8)) {
            opacity = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.3
        }
        
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            circleScale = 1.0
        }
    }
}

struct CustomLoader: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.primary.opacity(0.3), lineWidth: 3)
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0.0, to: 0.6)
                .stroke(
                    AngularGradient(
                        colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
                        center: .center,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360)
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Circle()
                .fill(AppColors.primary)
                .frame(width: 20, height: 20)
                .scaleEffect(isAnimating ? 1.2 : 0.8)
                .animation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct PulsingDots: View {
    @State private var animationPhase = 0.0
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(AppColors.primary)
                    .frame(width: 12, height: 12)
                    .scaleEffect(
                        1.0 + 0.5 * sin(animationPhase + Double(index) * 0.6)
                    )
                    .opacity(
                        0.5 + 0.5 * sin(animationPhase + Double(index) * 0.6)
                    )
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                animationPhase = .pi * 4
            }
        }
    }
}

#Preview {
    SplashView {
        print("Splash completed")
    }
}
