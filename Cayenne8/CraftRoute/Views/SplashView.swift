import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.accentBlue.opacity(0.3), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .stroke(ColorManager.accentOrange, lineWidth: 4)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(ColorManager.accentBlue)
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
                    
                    Image(systemName: "hammer.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                Text("Loading...")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .opacity(isAnimating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        pulseScale = 1.3
        rotationAngle = 360
    }
}

#Preview {
    SplashView()
}
