import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.primaryBlue.opacity(0.3), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorManager.primaryBlue, ColorManager.primaryYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    
                    Circle()
                        .fill(ColorManager.primaryYellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                Text("Loading...")
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .opacity(isAnimating ? 1.0 : 0.6)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            isAnimating = true
        }
    }
}
