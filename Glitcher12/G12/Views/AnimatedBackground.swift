import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ColorManager.primaryBackground
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ForEach(0..<15, id: \.self) { index in
                    FloatingBall(
                        index: index,
                        size: CGFloat.random(in: 40...120),
                        duration: Double.random(in: 8...15),
                        delay: Double(index) * 0.3,
                        screenSize: geometry.size
                    )
                }
            }
        }
    }
}

struct FloatingBall: View {
    let index: Int
    let size: CGFloat
    let duration: Double
    let delay: Double
    let screenSize: CGSize
    
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0.3
    @State private var offsetX: CGFloat = 0
    @State private var offsetY: CGFloat = 0
    
    private var colors: [Color] {
        [ColorManager.ballColor1, ColorManager.ballColor2, ColorManager.ballColor3, ColorManager.ballColor4]
    }
    
    private var ballColor: Color {
        colors[index % colors.count]
    }
    
    var body: some View {
        Circle()
            .fill(ballColor)
            .frame(width: size, height: size)
            .position(
                x: position.x + offsetX,
                y: position.y + offsetY
            )
            .opacity(opacity)
            .blur(radius: size * 0.1)
            .onAppear {
                startPosition()
                startAnimation()
            }
    }
    
    private func startPosition() {
        let randomX = CGFloat.random(in: 0...screenSize.width)
        let randomY = CGFloat.random(in: 0...screenSize.height)
        position = CGPoint(x: randomX, y: randomY)
    }
    
    private func startAnimation() {
        let maxOffset: CGFloat = 200
        
        withAnimation(
            Animation.easeInOut(duration: duration)
                .repeatForever(autoreverses: true)
                .delay(delay)
        ) {
            offsetX = CGFloat.random(in: -maxOffset...maxOffset)
            offsetY = CGFloat.random(in: -maxOffset...maxOffset)
        }
        
        withAnimation(
            Animation.easeInOut(duration: duration * 0.7)
                .repeatForever(autoreverses: true)
                .delay(delay)
        ) {
            opacity = Double.random(in: 0.15...0.4)
        }
    }
}

#Preview {
    AnimatedBackground()
}
