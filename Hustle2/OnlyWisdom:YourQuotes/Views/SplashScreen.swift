import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            DesignSystem.Gradients.backgroundGradient
                .ignoresSafeArea()
            
            BlueWebPattern()
                .opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: DesignSystem.Spacing.xl) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            DesignSystem.Colors.lightBlue.opacity(0.3),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(2 - pulseScale)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [
                                    DesignSystem.Colors.primaryBlue,
                                    DesignSystem.Colors.lightBlue,
                                    DesignSystem.Colors.darkBlue
                                ],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Image(systemName: "quote.bubble")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(DesignSystem.Colors.primaryBlue)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Text("Loading")
                        .font(FontManager.poppinsMedium(size: 18))
                        .foregroundColor(DesignSystem.Colors.textDark)
                        .opacity(opacity)
                    
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(DesignSystem.Colors.primaryBlue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    onComplete()
                }
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        
        withAnimation(.easeOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
    }
}

#Preview {
    SplashScreen {
        print("Splash completed")
    }
}
