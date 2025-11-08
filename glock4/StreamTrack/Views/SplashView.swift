import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var innerRotation: Double = 0
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    AppColors.primaryBlue,
                                    AppColors.lightBlue,
                                    AppColors.primaryBlue.opacity(0.3),
                                    AppColors.primaryBlue
                                ]),
                                center: .center
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    AppColors.lightBlue.opacity(0.8),
                                    AppColors.primaryBlue.opacity(0.4),
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 30
                            )
                        )
                        .frame(width: 60, height: 60)
                        .scaleEffect(pulseScale)
                    
                    Circle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: 12, height: 12)
                        .rotationEffect(.degrees(innerRotation))
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.lightBlue.opacity(0.7))
                            .frame(width: 6, height: 6)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 60 + innerRotation))
                    }
                }
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.5)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            showContent = true
        }
        
        withAnimation(
            Animation.linear(duration: 2)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            Animation.linear(duration: 3)
                .repeatForever(autoreverses: false)
        ) {
            innerRotation = -360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.2
        }
    }
}
