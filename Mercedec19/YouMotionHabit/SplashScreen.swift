import SwiftUI

struct SplashScreen: View {
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var pulseScale: CGFloat = 1.0
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.primaryWhite.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    ColorTheme.primaryYellow,
                                    ColorTheme.primaryWhite
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(ColorTheme.primaryYellow)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 45 + rotationAngle * 0.5))
                            .opacity(sin(rotationAngle * .pi / 180 + Double(index) * .pi / 4) * 0.5 + 0.5)
                    }
                    
                    Image(systemName: "bolt.heart.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(ColorTheme.primaryWhite)
                        .scaleEffect(scale)
                }
                .opacity(opacity)
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            opacity = 1
        }
        
        withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
            scale = 1.1
        }
        
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
    }
}
