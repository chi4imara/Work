import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var innerCircleScale: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseScale)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorTheme.primaryYellow, ColorTheme.accentOrange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotationAngle)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [ColorTheme.primaryBlue, ColorTheme.darkBlue],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(innerCircleScale)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: innerCircleScale)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(ColorTheme.accentPink.opacity(0.7))
                            .frame(width: 8, height: 8)
                            .offset(
                                x: cos(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 60,
                                y: sin(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 60
                            )
                            .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: rotationAngle)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        pulseScale = 1.3
        rotationAngle = 360
        innerCircleScale = 1.2
    }
}
