import SwiftUI

struct AnimatedBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            AnimatedGradientBackground(animate: $animateGradient)
            
            MovingSpheres()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct AnimatedGradientBackground: View {
    @Binding var animate: Bool
    
    var body: some View {
        LinearGradient(
            colors: animate ? [
                Color(red: 0.5, green: 0.7, blue: 1.0),
                Color(red: 0.3, green: 0.6, blue: 0.9),
                Color(red: 0.4, green: 0.65, blue: 0.95)
            ] : [
                Color(red: 0.3, green: 0.6, blue: 0.9),
                Color(red: 0.5, green: 0.7, blue: 1.0),
                Color(red: 0.4, green: 0.65, blue: 0.95)
            ],
            startPoint: animate ? .topTrailing : .topLeading,
            endPoint: animate ? .bottomLeading : .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct MovingSpheres: View {
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                MovingSphere(
                    delay: Double(index) * 0.5,
                    size: CGFloat.random(in: 20...80),
                    color: ColorTheme.sphereColors.randomElement() ?? Color.white.opacity(0.1)
                )
            }
        }
    }
}

struct MovingSphere: View {
    let delay: Double
    let size: CGFloat
    let color: Color
    
    @State private var position = CGPoint(x: 0, y: 0)
    @State private var opacity: Double = 0
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(position)
            .opacity(opacity)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        position = CGPoint(
            x: CGFloat.random(in: -100...UIScreen.main.bounds.width + 100),
            y: CGFloat.random(in: -100...UIScreen.main.bounds.height + 100)
        )
        
        withAnimation(.easeIn(duration: 1).delay(delay)) {
            opacity = 1
        }
        
        animateMovement()
    }
    
    private func animateMovement() {
        let duration = Double.random(in: 8...15)
        let newPosition = CGPoint(
            x: CGFloat.random(in: -100...UIScreen.main.bounds.width + 100),
            y: CGFloat.random(in: -100...UIScreen.main.bounds.height + 100)
        )
        
        withAnimation(.linear(duration: duration)) {
            position = newPosition
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            animateMovement()
        }
    }
}

#Preview {
    AnimatedBackground()
}
