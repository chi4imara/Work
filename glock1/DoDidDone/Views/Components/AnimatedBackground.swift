import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                FloatingCircle(
                    size: CGFloat.random(in: 20...80),
                    delay: Double(index) * 0.5,
                    duration: Double.random(in: 3...6)
                )
            }
        }
    }
}

struct FloatingCircle: View {
    let size: CGFloat
    let delay: Double
    let duration: Double
    
    @State private var moveUp = false
    @State private var moveRight = false
    @State private var opacity: Double = 0.1
    
    var body: some View {
        Circle()
            .fill(AppColors.floatingWhite)
            .frame(width: size, height: size)
            .opacity(opacity)
            .offset(
                x: moveRight ? 100 : -100,
                y: moveUp ? -200 : 200
            )
            .animation(
                Animation.easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: moveUp
            )
            .animation(
                Animation.easeInOut(duration: duration * 1.2)
                    .repeatForever(autoreverses: true)
                    .delay(delay + 0.5),
                value: moveRight
            )
            .onAppear {
                moveUp.toggle()
                moveRight.toggle()
                
                withAnimation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    opacity = Double.random(in: 0.05...0.3)
                }
            }
    }
}

#Preview {
    AnimatedBackground()
}
