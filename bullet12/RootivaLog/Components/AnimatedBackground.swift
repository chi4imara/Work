import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                MovingOrb(
                    color: orbColor(for: index),
                    size: orbSize(for: index),
                    duration: orbDuration(for: index),
                    delay: orbDelay(for: index)
                )
            }
        }
    }
    
    private func orbColor(for index: Int) -> Color {
        switch index % 3 {
        case 0:
            return AppColors.orbBlue1
        case 1:
            return AppColors.orbBlue2
        default:
            return AppColors.orbBlue3
        }
    }
    
    private func orbSize(for index: Int) -> CGFloat {
        let sizes: [CGFloat] = [60, 80, 40, 100, 50, 70]
        return sizes[index % sizes.count]
    }
    
    private func orbDuration(for index: Int) -> Double {
        let durations: [Double] = [8, 12, 6, 10, 7, 9]
        return durations[index % durations.count]
    }
    
    private func orbDelay(for index: Int) -> Double {
        return Double(index) * 0.5
    }
}

struct MovingOrb: View {
    let color: Color
    let size: CGFloat
    let duration: Double
    let delay: Double
    
    @State private var position = CGPoint(x: 0, y: 0)
    @State private var opacity: Double = 0.3
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(position)
            .opacity(opacity)
            .blur(radius: 2)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            animateOrb()
        }
    }
    
    private func animateOrb() {
        withAnimation(
            Animation.easeInOut(duration: duration)
                .repeatForever(autoreverses: true)
        ) {
            position = CGPoint(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
            )
        }
        
        withAnimation(
            Animation.easeInOut(duration: duration / 2)
                .repeatForever(autoreverses: true)
        ) {
            opacity = Double.random(in: 0.2...0.6)
        }
    }
}

#Preview {
    AnimatedBackground()
}
