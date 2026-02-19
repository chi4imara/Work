import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var innerRotation: Double = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    ColorTheme.primaryYellow,
                                    ColorTheme.accentOrange,
                                    ColorTheme.primaryYellow
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 8
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(ColorTheme.primaryWhite)
                            .frame(width: 12, height: 12)
                            .offset(y: -40)
                            .rotationEffect(.degrees(Double(index) * 60 + innerRotation))
                    }
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    ColorTheme.primaryYellow,
                                    ColorTheme.accentOrange
                                ]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .scaleEffect(pulseScale)
                }
                .onAppear {
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        rotationAngle = 360
                    }
                    
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        innerRotation = 360
                    }
                    
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        pulseScale = 1.3
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    }
                }
                
                Spacer()
            }
        }
    }
}
