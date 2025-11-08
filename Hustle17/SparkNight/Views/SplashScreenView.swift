import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            ColorTheme.primaryBlue.opacity(0.3),
                            style: StrokeStyle(lineWidth: 4, dash: [10, 5])
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .stroke(
                            ColorTheme.darkBlue.opacity(0.6),
                            style: StrokeStyle(lineWidth: 3)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-rotationAngle * 1.5))
                    
                    Circle()
                        .fill(ColorTheme.blueGradient)
                        .frame(width: 40, height: 40)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(ColorTheme.textLight)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .opacity(isAnimating ? 1.0 : 0.7)
                }
                .opacity(opacity)
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(.theme.title3)
                        .foregroundColor(ColorTheme.textPrimary)
                        .opacity(opacity)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(ColorTheme.primaryBlue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                    .opacity(opacity)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onComplete()
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.5)) {
            opacity = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 3.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.3
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashScreenView {
        print("Splash completed")
    }
}
