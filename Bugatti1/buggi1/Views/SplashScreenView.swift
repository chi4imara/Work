import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.3
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showSecondaryAnimation = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: AppSpacing.xl) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.secondary, lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(1.0 - (pulseScale - 1.0))
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0.2, to: 0.8)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.secondary, AppColors.warning],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(AppColors.textPrimary)
                            .frame(width: 8, height: 8)
                            .offset(
                                x: cos(Double(index) * .pi / 4) * 60,
                                y: sin(Double(index) * .pi / 4) * 60
                            )
                            .scaleEffect(showSecondaryAnimation ? 1.5 : 0.5)
                            .opacity(showSecondaryAnimation ? 0.8 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.8)
                                    .delay(Double(index) * 0.1)
                                    .repeatForever(autoreverses: true),
                                value: showSecondaryAnimation
                            )
                    }
                }
                
                Spacer()
                
                HStack(spacing: AppSpacing.sm) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(AppColors.textPrimary)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .delay(Double(index) * 0.2)
                                    .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                }
                .padding(.bottom, AppSpacing.xxl)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
            rotationAngle = 360
            pulseScale = 1.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showSecondaryAnimation = true
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            rotationAngle += 360
        }
    }
}

#Preview {
    SplashScreenView()
}
