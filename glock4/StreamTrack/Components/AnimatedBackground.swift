import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                FloatingOrb(
                    color: AppColors.orbColors[index % AppColors.orbColors.count],
                    size: CGFloat.random(in: 40...120),
                    initialOffset: CGPoint(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -300...300)
                    ),
                    animate: $animate
                )
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 20)
                    .repeatForever(autoreverses: false)
            ) {
                animate = true
            }
        }
    }
}

struct FloatingOrb: View {
    let color: Color
    let size: CGFloat
    let initialOffset: CGPoint
    @Binding var animate: Bool
    
    @State private var position: CGPoint = .zero
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.8
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.8),
                        color.opacity(0.3),
                        color.opacity(0.1)
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(position)
            .blur(radius: 2)
            .onAppear {
                position = CGPoint(
                    x: UIScreen.main.bounds.width / 2 + initialOffset.x,
                    y: UIScreen.main.bounds.height / 2 + initialOffset.y
                )
                
                startAnimations()
            }
    }
    
    private func startAnimations() {
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 8...15))
                .repeatForever(autoreverses: true)
        ) {
            position = CGPoint(
                x: position.x + CGFloat.random(in: -150...150),
                y: position.y + CGFloat.random(in: -200...200)
            )
        }
        
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 3...6))
                .repeatForever(autoreverses: true)
        ) {
            scale = CGFloat.random(in: 0.8...1.2)
        }
        
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 4...8))
                .repeatForever(autoreverses: true)
        ) {
            opacity = Double.random(in: 0.3...0.8)
        }
    }
}

struct PulsingOrb: View {
    let color: Color
    let size: CGFloat
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.6
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.6),
                        color.opacity(0.2),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                ) {
                    scale = 1.2
                    opacity = 0.2
                }
            }
    }
}

#Preview {
    AnimatedBackground()
}
