import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.accentYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(0.8)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(ColorTheme.primaryText)
                            .frame(width: 12, height: 12)
                            .offset(y: -40)
                            .rotationEffect(.degrees(rotationAngle + Double(index * 60)))
                            .opacity(opacity)
                    }
                    
                    Circle()
                        .fill(ColorTheme.accentYellow)
                        .frame(width: 30, height: 30)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(opacity)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.8)) {
            opacity = 1
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
        
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            isAnimating.toggle()
        }
        
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}
