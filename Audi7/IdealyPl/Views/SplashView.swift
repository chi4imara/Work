import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.accentYellow, AppColors.primaryText],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.primaryText)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(AppColors.accentYellow.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .offset(
                                x: cos(Double(index) * .pi / 4) * 60,
                                y: sin(Double(index) * .pi / 4) * 60
                            )
                            .scaleEffect(isAnimating ? 1.0 : 0.3)
                            .rotationEffect(.degrees(rotationAngle * 0.5))
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
    }
}
