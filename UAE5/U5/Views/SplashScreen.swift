import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            ColorManager.radialGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorManager.accentBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(
                            ColorManager.angularGradient,
                            lineWidth: 6
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                    
                    Circle()
                        .fill(ColorManager.primaryText)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
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
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
        }
        
        withAnimation(
            Animation.linear(duration: 3.0)
                .repeatForever(autoreverses: false)
        ) {
            rotation = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            scale = 1.2
            opacity = 1.0
        }
    }
}

#Preview {
    SplashScreen()
}
