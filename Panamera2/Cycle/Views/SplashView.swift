import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.accentYellow, lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(AppColors.primaryWhite, lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .overlay(
                            Circle()
                                .fill(AppColors.accentYellow)
                                .frame(width: 8, height: 8)
                                .offset(y: -40)
                                .rotationEffect(.degrees(rotation))
                        )
                    
                    Circle()
                        .fill(AppColors.primaryWhite)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
}

#Preview {
    SplashView()
}
