import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @Binding var isShowingSplash: Bool
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .stroke(AppColors.primaryYellow, lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: 40, height: 40)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(.bellGothic(size: 18))
                    .foregroundColor(AppColors.primaryBlue)
                    .opacity(isAnimating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isShowingSplash = false
                }
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        pulseScale = 1.3
        rotationAngle = 360
    }
}

#Preview {
    SplashView(isShowingSplash: .constant(true))
}
