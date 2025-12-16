import SwiftUI

struct FloatingOrb: View {
    @State private var position = CGPoint.zero
    @State private var opacity: Double = 0.3
    @State private var scale: CGFloat = 1.0
    
    let size: CGFloat
    let color: Color
    let animationDuration: Double
    
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
        withAnimation(
            Animation.easeInOut(duration: animationDuration)
                .repeatForever(autoreverses: true)
        ) {
            position = CGPoint(
                x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
                y: CGFloat.random(in: 100...UIScreen.main.bounds.height - 100)
            )
            opacity = Double.random(in: 0.1...0.4)
            scale = CGFloat.random(in: 0.5...1.5)
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
            withAnimation(
                Animation.easeInOut(duration: animationDuration)
            ) {
                position = CGPoint(
                    x: CGFloat.random(in: 50...UIScreen.main.bounds.width - 50),
                    y: CGFloat.random(in: 100...UIScreen.main.bounds.height - 100)
                )
                opacity = Double.random(in: 0.1...0.4)
                scale = CGFloat.random(in: 0.5...1.5)
            }
        }
    }
}

struct AnimatedBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                FloatingOrb(
                    size: CGFloat.random(in: 20...80),
                    color: [Color.theme.orbColor1, Color.theme.orbColor2, Color.theme.orbColor3].randomElement() ?? Color.theme.orbColor1,
                    animationDuration: Double.random(in: 3...8)
                )
            }
        }
    }
}

#Preview {
    AnimatedBackground()
}
