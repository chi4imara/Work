import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.3
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.primaryYellow, AppColors.primaryBlue, AppColors.accentPink],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.primaryYellow.opacity(0.8), AppColors.primaryBlue.opacity(0.6)],
                                center: .center,
                                startRadius: 10,
                                endRadius: 30
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(AppColors.backgroundWhite)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.textBlue)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.bottom, 50)
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
        
        withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            scale = 1.2
            opacity = 1.0
        }
    }
}

#Preview {
    SplashScreen()
}
