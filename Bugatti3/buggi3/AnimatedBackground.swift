import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(Color.theme.lightBlue.opacity(0.35))
                    .frame(width: CGFloat.random(in: 20...80))
                    .position(
                        x: animate ? CGFloat.random(in: 0...400) : CGFloat.random(in: 0...400),
                        y: animate ? CGFloat.random(in: 0...800) : CGFloat.random(in: 0...800)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animate
                    )
            }
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(Color.theme.lightBlue.opacity(0.2))
                    .frame(width: animate ? 150 : 50)
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: CGFloat.random(in: 100...700)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 2...5))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...3)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    AnimatedBackground()
}
