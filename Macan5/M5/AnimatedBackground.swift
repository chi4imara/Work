import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                FloatingOrb(
                    color: ColorManager.orbColors[index % ColorManager.orbColors.count],
                    size: CGFloat.random(in: 20...60),
                    initialOffset: CGPoint(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -300...300)
                    ),
                    animate: $animate
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

struct FloatingOrb: View {
    let color: Color
    let size: CGFloat
    let initialOffset: CGPoint
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .fill(color.opacity(0.3))
            .frame(width: size, height: size)
            .blur(radius: 2)
            .offset(
                x: animate ? initialOffset.x + CGFloat.random(in: -100...100) : initialOffset.x,
                y: animate ? initialOffset.y + CGFloat.random(in: -150...150) : initialOffset.y
            )
            .animation(.easeInOut(duration: Double.random(in: 2...4)).repeatForever(autoreverses: true), value: animate)
    }
}

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorManager.primaryBlue.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorManager.primaryBlue, ColorManager.primaryYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: rotationAngle)
                    
                    Circle()
                        .fill(ColorManager.primaryYellow.opacity(0.6))
                        .frame(width: 60, height: 60)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scale)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            }
        }
    }
    
    private func startAnimations() {
        rotationAngle = 360
        scale = 1.2
        opacity = 1.0
    }
}
