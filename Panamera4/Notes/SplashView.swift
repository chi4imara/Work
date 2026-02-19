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
                        .stroke(AppColors.primaryWhite.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(AppColors.accentYellow, lineWidth: 4)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .opacity(0.8)
                    
                    Circle()
                        .fill(AppColors.primaryWhite)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AppColors.primaryPink)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(.bellGothic(18, weight: .regular))
                    .foregroundColor(AppColors.primaryWhite)
                    .opacity(isAnimating ? 1.0 : 0.6)
                
                Spacer().frame(height: 100)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
    }
}

#Preview {
    SplashView()
}
