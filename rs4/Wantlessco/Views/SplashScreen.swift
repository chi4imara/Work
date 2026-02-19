import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var scale = 0.5
    @State private var opacity = 0.5
    @State private var rotationAngle = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 2)
                        .frame(width: 100, height: 100)
                        .scaleEffect(pulseScale)
                        .opacity(2 - pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [AppColors.primaryPurple, AppColors.lightPurple, AppColors.primaryText]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 1)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [AppColors.primaryText, AppColors.lightPurple]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 15
                            )
                        )
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
            pulseScale = 2.0
        }
    }
}
