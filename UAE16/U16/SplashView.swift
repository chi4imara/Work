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
            
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(AppColors.orange, lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.lightBlue)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(AppColors.white)
                        .frame(width: 12, height: 12)
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(.ubuntu(size: 18, weight: .medium))
                    .foregroundColor(AppColors.white)
                    .opacity(isAnimating ? 1.0 : 0.5)
                
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
            rotationAngle = 360
        }
    }
}

#Preview {
    SplashView()
}
