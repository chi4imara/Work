import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject private var appState: AppStateManager
    @State private var animationPhase = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(opacity)
                    
                    ZStack {
                        ForEach(0..<8, id: \.self) { index in
                            Circle()
                                .fill(AppColors.primaryText)
                                .frame(width: 8, height: 8)
                                .offset(y: -35)
                                .rotationEffect(.degrees(Double(index) * 45 + rotationAngle))
                                .opacity(animationPhase == index ? 1.0 : 0.3)
                        }
                    }
                    .frame(width: 80, height: 80)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.accentYellow, AppColors.accentYellow.opacity(0.3)],
                                center: .center,
                                startRadius: 5,
                                endRadius: 20
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(pulseScale * 0.8)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                animationPhase = (animationPhase + 1) % 8
            }
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
            opacity = 0.8
        }
    }
}
