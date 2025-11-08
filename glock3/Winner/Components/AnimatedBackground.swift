import SwiftUI

struct AnimatedBackground: View {
    @State private var animateCircles = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...80))
                    .position(
                        x: animateCircles ? CGFloat.random(in: 0...400) : CGFloat.random(in: 0...400),
                        y: animateCircles ? CGFloat.random(in: 0...800) : CGFloat.random(in: 0...800)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animateCircles
                    )
            }
            
            ForEach(0..<25, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: CGFloat.random(in: 5...15))
                    .position(
                        x: animateCircles ? CGFloat.random(in: 0...400) : CGFloat.random(in: 0...400),
                        y: animateCircles ? CGFloat.random(in: 0...800) : CGFloat.random(in: 0...800)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 5...12))
                            .repeatForever(autoreverses: false)
                            .delay(Double.random(in: 0...3)),
                        value: animateCircles
                    )
            }
        }
        .onAppear {
            animateCircles = true
        }
    }
}

#Preview {
    AnimatedBackground()
}
