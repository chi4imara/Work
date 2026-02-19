import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                MovingOrb(index: index, animate: $animate)
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: Double.random(in: 15...25))
                    .repeatForever(autoreverses: false)
            ) {
                animate.toggle()
            }
        }
    }
}

struct MovingOrb: View {
    let index: Int
    @Binding var animate: Bool
    
    private var orbSize: CGFloat {
        CGFloat.random(in: 20...60)
    }
    
    private var animationDuration: Double {
        Double.random(in: 10...20)
    }
    
    private var startPosition: CGPoint {
        CGPoint(
            x: CGFloat.random(in: -100...UIScreen.main.bounds.width + 100),
            y: CGFloat.random(in: -100...UIScreen.main.bounds.height + 100)
        )
    }
    
    private var endPosition: CGPoint {
        CGPoint(
            x: CGFloat.random(in: -100...UIScreen.main.bounds.width + 100),
            y: CGFloat.random(in: -100...UIScreen.main.bounds.height + 100)
        )
    }
    
    @State private var position: CGPoint = CGPoint.zero
    @State private var opacity: Double = 0.0
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        ColorTheme.movingOrbColor,
                        ColorTheme.movingOrbColor.opacity(0.3),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: orbSize / 2
                )
            )
            .frame(width: orbSize, height: orbSize)
            .position(position)
            .opacity(opacity)
            .blur(radius: 1)
            .onAppear {
                position = startPosition
                
                withAnimation(
                    Animation.linear(duration: animationDuration)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.5)
                ) {
                    position = endPosition
                }
                
                withAnimation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3)
                ) {
                    opacity = Double.random(in: 0.3...0.8)
                }
            }
    }
}

#Preview {
    AnimatedBackground()
}
