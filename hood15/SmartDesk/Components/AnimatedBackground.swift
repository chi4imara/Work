import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.background,
                    AppColors.lightBlue.opacity(0.3),
                    AppColors.background
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                AppColors.secondaryBlue.opacity(0.3),
                                AppColors.primaryBlue.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 10,
                            endRadius: 100
                        )
                    )
                    .frame(width: CGFloat.random(in: 80...150))
                    .position(
                        x: animate ? CGFloat.random(in: 50...350) : CGFloat.random(in: 50...350),
                        y: animate ? CGFloat.random(in: 100...700) : CGFloat.random(in: 100...700)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
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

struct FloatingOrb: View {
    let size: CGFloat
    let color: Color
    @State private var offset = CGSize.zero
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.4),
                        color.opacity(0.2),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 5,
                    endRadius: size/2
                )
            )
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .offset(offset)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                ) {
                    offset = CGSize(
                        width: CGFloat.random(in: -50...50),
                        height: CGFloat.random(in: -50...50)
                    )
                    scale = CGFloat.random(in: 0.8...1.2)
                }
            }
    }
}
