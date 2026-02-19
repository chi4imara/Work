import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.3
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(AppColors.yellow.opacity(0.3), lineWidth: 2)
                            .frame(width: 120 + CGFloat(index * 20), height: 120 + CGFloat(index * 20))
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .opacity(isAnimating ? 0.1 : 0.6)
                            .animation(
                                Animation.easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                value: isAnimating
                            )
                    }
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.yellow, AppColors.brightYellow, AppColors.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(AppColors.yellow)
                        .frame(width: 12, height: 12)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: scale
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
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        rotationAngle = 360
        scale = 1.5
        opacity = 1.0
    }
}
