import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.yellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorManager.yellow, ColorManager.goldenYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(ColorManager.yellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.3 : 0.7)
                        .opacity(isAnimating ? 1.0 : 0.6)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                Text("Loading...")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.white.opacity(0.8))
                    .opacity(isAnimating ? 1.0 : 0.5)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.splashDuration) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(.easeOut(duration: 0.8)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}
