import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.accentYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(ColorManager.purpleGradient, lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(ColorManager.primaryText)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(ColorManager.accentYellow)
                        .frame(width: 12, height: 12)
                        .scaleEffect(isAnimating ? 1.5 : 0.5)
                }
                
                Text("Loading your style diary...")
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.2
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

