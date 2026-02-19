import SwiftUI

struct AnimatedBackground: View {
    @State private var animateCircles = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.appLightBlue.opacity(0.6),
                                    Color.appPrimary.opacity(0.3)
                                ]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 50
                            )
                        )
                        .frame(width: CGFloat.random(in: 20...80), height: CGFloat.random(in: 20...80))
                        .position(
                            x: animateCircles ? 
                                CGFloat.random(in: 0...geometry.size.width) : 
                                CGFloat.random(in: 0...geometry.size.width),
                            y: animateCircles ? 
                                CGFloat.random(in: 0...geometry.size.height) : 
                                CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...6))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.5),
                            value: animateCircles
                        )
                }
                
                ForEach(0..<15, id: \.self) { index in
                    Circle()
                        .fill(Color.appLightBlue.opacity(0.2))
                        .frame(width: CGFloat.random(in: 5...15), height: CGFloat.random(in: 5...15))
                        .position(
                            x: animateCircles ? 
                                CGFloat.random(in: 0...geometry.size.width) : 
                                CGFloat.random(in: 0...geometry.size.width),
                            y: animateCircles ? 
                                CGFloat.random(in: 0...geometry.size.height) : 
                                CGFloat.random(in: 0...geometry.size.height)
                        )
                        .animation(
                            Animation.linear(duration: Double.random(in: 8...12))
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 0.3),
                            value: animateCircles
                        )
                }
            }
        }
        .onAppear {
            animateCircles = true
        }
    }
}

struct StaticBackground: View {
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.appLightBlue.opacity(0.1),
                    Color.clear,
                    Color.appPrimary.opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    AnimatedBackground()
}
