import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(0.6)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primaryYellow, AppColors.primaryBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.primaryYellow, AppColors.primaryYellow.opacity(0.3)],
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 20, height: 20)
                        .scaleEffect(pulseScale * 0.8)
                }
                .opacity(opacity)
                
                Spacer()
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
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.8)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
    }
}

