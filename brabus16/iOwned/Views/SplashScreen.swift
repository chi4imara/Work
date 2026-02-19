import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scaleEffect: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.3
    @State private var circleOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.primaryBlue.opacity(pulseOpacity), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(scaleEffect)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [ColorTheme.primaryYellow, ColorTheme.primaryBlue, ColorTheme.accentGreen],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(ColorTheme.primaryYellow)
                            .frame(width: 12, height: 12)
                            .offset(y: circleOffset)
                            .rotationEffect(.degrees(Double(index) * 120))
                            .animation(
                                .easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: circleOffset
                            )
                    }
                    
                    Circle()
                        .fill(ColorTheme.primaryBlue)
                        .frame(width: 8, height: 8)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + AppConstants.splashScreenDuration) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        DispatchQueue.main.async {
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                scaleEffect = 1.3
                pulseOpacity = 0.8
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                circleOffset = -20
            }
        }
    }
}
