import SwiftUI

struct AnimatedBackground: View {
    @State private var animateCircles = false
    
    var body: some View {
        ZStack {
            AppTheme.Colors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.1...0.3)))
                    .frame(width: CGFloat.random(in: 20...80))
                    .position(
                        x: animateCircles ? CGFloat.random(in: 0...UIScreen.main.bounds.width) : CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: animateCircles ? CGFloat.random(in: 0...UIScreen.main.bounds.height) : CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 15...25))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...5)),
                        value: animateCircles
                    )
            }
            
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.1),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
        .onAppear {
            animateCircles = true
        }
    }
}

struct PulsingCircle: View {
    @State private var isPulsing = false
    let size: CGFloat
    let opacity: Double
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(opacity))
            .frame(width: size, height: size)
            .scaleEffect(isPulsing ? 1.2 : 0.8)
            .opacity(isPulsing ? 0.3 : 0.7)
            .animation(
                Animation.easeInOut(duration: Double.random(in: 2...4))
                    .repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

#Preview {
    AnimatedBackground()
}
