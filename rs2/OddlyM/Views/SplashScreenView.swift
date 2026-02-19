import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(AppColors.accentPurple.opacity(0.3), lineWidth: 4)
                        .frame(width: 100, height: 100)
                        .scaleEffect(isAnimating ? 1.3 : 1.0)
                        .opacity(isAnimating ? 0.0 : 1.0)
                    
                    Circle()
                        .stroke(AppColors.accentPurple.opacity(0.5), lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(AppColors.accentPurple, lineWidth: 4)
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(rotation))
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}
