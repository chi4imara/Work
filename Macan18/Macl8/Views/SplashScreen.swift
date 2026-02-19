import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AppTheme.Gradients.splashGradient
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.xl) {
                ZStack {
                    Circle()
                        .stroke(AppTheme.Colors.accent.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(2 - pulseScale)
                    
                    Circle()
                        .stroke(AppTheme.Colors.accent.opacity(0.6), lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppTheme.Gradients.accentGradient)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(AppTheme.Colors.primaryText)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                }
                
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppTheme.Colors.accent)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .opacity(isAnimating ? 1.0 : 0.5)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.top, AppTheme.Spacing.lg)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
        
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashScreen()
}
