import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                FloatingOrb(
                    size: CGFloat.random(in: 20...80),
                    color: [Color.orbColor1, Color.orbColor2, Color.orbColor3].randomElement() ?? Color.orbColor1,
                    delay: Double(index) * 0.5
                )
            }
        }
    }
}

struct FloatingOrb: View {
    let size: CGFloat
    let color: Color
    let delay: Double
    
    @State private var position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.0
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(position)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 1.0).delay(delay)) {
            opacity = 1.0
            scale = 1.0
        }
        
        Timer.scheduledTimer(withTimeInterval: delay + 1.0, repeats: false) { _ in
            animateMovement()
        }
    }
    
    private func animateMovement() {
        withAnimation(.linear(duration: Double.random(in: 8...15)).repeatForever(autoreverses: false)) {
            position = CGPoint(
                x: CGFloat.random(in: -size...UIScreen.main.bounds.width + size),
                y: CGFloat.random(in: -size...UIScreen.main.bounds.height + size)
            )
        }
        
        withAnimation(.easeInOut(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true)) {
            scale = CGFloat.random(in: 0.8...1.2)
            opacity = Double.random(in: 0.3...1.0)
        }
    }
}

#Preview {
    AnimatedBackground()
}
