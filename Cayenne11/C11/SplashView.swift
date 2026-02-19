import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.deepBlue,
                    AppColors.darkBlue,
                    AppColors.lightBlue.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.lightBlue, AppColors.orange, AppColors.lightBlue],
                                center: .center
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.primaryText)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
            pulseScale = 1.3
            rotationAngle = 360
        }
    }
}

#Preview {
    SplashView()
}
