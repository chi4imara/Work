import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.backgroundWhite,
                    Color.lightBlue.opacity(0.3),
                    Color.backgroundWhite
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.primaryBlue.opacity(0.3),
                                Color.lightBlue.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 5,
                            endRadius: 50
                        )
                    )
                    .frame(
                        width: CGFloat.random(in: 20...80),
                        height: CGFloat.random(in: 20...80)
                    )
                    .position(
                        x: animate ? CGFloat.random(in: 0...UIScreen.main.bounds.width) : CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: animate ? CGFloat.random(in: 0...UIScreen.main.bounds.height) : CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
        .ignoresSafeArea()
    }
}

struct FloatingBubble: View {
    let size: CGFloat
    let color: Color
    @State private var yOffset: CGFloat = 0
    @State private var xOffset: CGFloat = 0
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.4),
                        color.opacity(0.1)
                    ]),
                    center: .center,
                    startRadius: size * 0.1,
                    endRadius: size * 0.5
                )
            )
            .frame(width: size, height: size)
            .offset(x: xOffset, y: yOffset)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: Double.random(in: 4...8))
                        .repeatForever(autoreverses: true)
                ) {
                    yOffset = CGFloat.random(in: -100...100)
                    xOffset = CGFloat.random(in: -50...50)
                }
            }
    }
}
