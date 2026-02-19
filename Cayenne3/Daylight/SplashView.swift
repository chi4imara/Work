import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: AppSpacing.xl) {
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.orange, AppColors.lightBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.lightBlue.opacity(0.8), AppColors.orange.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(AppColors.primaryText)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.5 : 0.5)
                }
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                
                HStack(spacing: AppSpacing.sm) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.lightBlue)
                            .frame(width: 12, height: 12)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
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
        withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            scale = 1.2
        }
        
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            opacity = 1.0
        }
        
        withAnimation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

#Preview {
    SplashView()
}
