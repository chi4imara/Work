import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale = 0.8
    @State private var opacity = 0.5
    @State private var rotation = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.appAccent.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [Color.appPrimary, Color.appAccent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 1.0)
                                .repeatForever(autoreverses: false),
                            value: rotation
                        )
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(Color.appAccent)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 45))
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.8)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                value: isAnimating
                            )
                    }
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
        
        isAnimating = true
    }
}

struct AnimatedBackground: View {
    @State private var animateCircles = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.appBackground,
                    Color.appBackground.opacity(0.8),
                    Color.appPrimary.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.appAccent.opacity(0.3),
                                Color.appPrimary.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 50
                        )
                    )
                    .frame(width: CGFloat.random(in: 60...120))
                    .position(
                        x: animateCircles ? CGFloat.random(in: 50...350) : CGFloat.random(in: 100...300),
                        y: animateCircles ? CGFloat.random(in: 100...700) : CGFloat.random(in: 200...600)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
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
    SplashScreen()
}
