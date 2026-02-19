import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: DesignSystem.Spacing.xl) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(DesignSystem.Colors.yellow.opacity(0.3), lineWidth: 4)
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
                            AngularGradient(
                                colors: [DesignSystem.Colors.yellow, DesignSystem.Colors.brightYellow, DesignSystem.Colors.yellow],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    RoundedRectangle(cornerRadius: isAnimating ? 20 : 4)
                        .fill(DesignSystem.Colors.primaryText)
                        .frame(
                            width: isAnimating ? 40 : 20,
                            height: isAnimating ? 40 : 20
                        )
                        .rotationEffect(.degrees(isAnimating ? 180 : 0))
                        .animation(
                            Animation.easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                Spacer()
                
                HStack(spacing: DesignSystem.Spacing.sm) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(DesignSystem.Colors.primaryText)
                            .frame(width: 8, height: 8)
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.bottom, DesignSystem.Spacing.xxl)
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
        isAnimating = true
        pulseScale = 1.2
        rotationAngle = 360
    }
}
