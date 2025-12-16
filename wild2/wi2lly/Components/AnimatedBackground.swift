import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
        }
    }
}

struct FloatingBubble: View {
    let size: CGFloat
    let delay: Double
    let duration: Double
    
    @State private var moveUp = false
    @State private var moveX = false
    @State private var opacity = 0.0
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.theme.lightBlue.opacity(0.6),
                        Color.theme.primaryBlue.opacity(0.3),
                        Color.clear
                    ],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .offset(
                x: moveX ? CGFloat.random(in: -100...100) : CGFloat.random(in: -50...50),
                y: moveUp ? -UIScreen.main.bounds.height - 100 : UIScreen.main.bounds.height + 100
            )
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: duration)
                        .repeatForever(autoreverses: false)
                        .delay(delay)
                ) {
                    moveUp.toggle()
                }
                
                withAnimation(
                    Animation.easeInOut(duration: duration / 2)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    moveX.toggle()
                }
                
                withAnimation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    opacity = Double.random(in: 0.3...0.8)
                }
            }
    }
}

#Preview {
    AnimatedBackground()
}
