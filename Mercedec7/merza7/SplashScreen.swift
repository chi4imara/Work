import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: AppSpacing.xl) {
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(AppColors.primaryYellow, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.bubbleColors[index % AppColors.bubbleColors.count])
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 60))
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 0.8)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                value: isAnimating
                            )
                    }
                    
                    Circle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: 12, height: 12)
                        .shadow(color: AppColors.primaryBlue, radius: 10)
                        .scaleEffect(pulseScale * 0.8)
                }
                .opacity(opacity)
                .animation(
                    Animation.easeIn(duration: 0.5),
                    value: opacity
                )
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        opacity = 1
        pulseScale = 1.3
        rotationAngle = 360
        isAnimating = true
    }
}
