import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(2.0 - pulseScale)
                    
                    Circle()
                        .stroke(ColorTheme.orange.opacity(0.6), lineWidth: 6)
                        .frame(width: 90, height: 90)
                        .rotationEffect(.degrees(rotation))
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    ColorTheme.lightBlue,
                                    ColorTheme.orange
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .scaleEffect(scale)
                        .shadow(color: ColorTheme.lightBlue.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    Circle()
                        .fill(ColorTheme.primaryText)
                        .frame(width: 12, height: 12)
                        .opacity(opacity)
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(ColorTheme.lightBlue)
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
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.5)) {
            opacity = 1.0
            scale = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashView()
}
