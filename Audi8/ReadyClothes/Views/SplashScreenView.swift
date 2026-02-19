import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.primaryYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(Color.primaryYellow, lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                    
                    Circle()
                        .fill(Color.primaryWhite)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primaryBlue)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Text("Loading...")
                    .font(.lumierepolis(18, weight: .light))
                    .foregroundColor(.textPrimary)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashScreenView()
}
