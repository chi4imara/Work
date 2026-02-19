import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primary.opacity(0.3), AppColors.secondary.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 140, height: 140)
                        .scaleEffect(pulseScale)
                        .opacity(isAnimating ? 0.4 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.secondary, AppColors.primary.opacity(0.8)],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 1.0 : 0.6)
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            pulseScale = 1.15
            isAnimating = true
        }
        
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            scale = 1.1
        }
        
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            opacity = 1.0
        }
    }
}

#Preview {
    SplashScreenView()
}
