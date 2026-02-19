import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryWhite.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(AppColors.primaryYellow, lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.primaryWhite)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(AppColors.accentPink)
                            .frame(width: 8, height: 8)
                            .offset(y: -50)
                            .rotationEffect(.degrees(Double(index) * 45 + rotationAngle * 0.5))
                            .opacity(isAnimating ? 1.0 : 0.3)
                    }
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

#Preview {
    SplashScreen()
}
