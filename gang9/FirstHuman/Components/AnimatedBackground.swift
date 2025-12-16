import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                FloatingOrb(
                    color: orbColor(for: index),
                    size: orbSize(for: index),
                    delay: Double(index) * 0.5
                )
            }
        }
    }
    
    private func orbColor(for index: Int) -> Color {
        let colors = [
            AppColors.orbBlue,
            AppColors.orbPurple,
            AppColors.orbYellow,
            AppColors.orbGreen,
            AppColors.orbPink
        ]
        return colors[index % colors.count]
    }
    
    private func orbSize(for index: Int) -> CGFloat {
        let sizes: [CGFloat] = [60, 80, 40, 100, 50, 70, 45, 90]
        return sizes[index % sizes.count]
    }
}

struct FloatingOrb: View {
    let color: Color
    let size: CGFloat
    let delay: Double
    
    @State private var position = CGPoint.zero
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: 20)
            .opacity(opacity)
            .position(position)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
        
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 8...15))
                .repeatForever(autoreverses: true)
                .delay(delay)
        ) {
            position = CGPoint(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
            )
        }
        
        withAnimation(
            Animation.easeInOut(duration: Double.random(in: 3...6))
                .repeatForever(autoreverses: true)
                .delay(delay + 1)
        ) {
            opacity = Double.random(in: 0.1...0.5)
        }
    }
}

#Preview {
    AnimatedBackground()
}
