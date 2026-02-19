import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AppColors.splashGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryWhite.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(0.7)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primaryYellow, AppColors.primaryWhite],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.8))
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(AppColors.primaryWhite)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.5 : 0.5)
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
        
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            isAnimating.toggle()
        }
    }
}

#Preview {
    SplashView()
}
