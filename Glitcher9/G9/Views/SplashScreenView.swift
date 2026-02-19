import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var pulseAnimation = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .opacity(pulseAnimation ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AppColors.buttonGradient,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.cardGradient)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "wrench.and.screwdriver")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.appWhite)
                            .scaleEffect(isAnimating ? 1.1 : 0.9)
                    }
                }
                
                Text("Loading...")
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(.appWhite)
                    .opacity(isAnimating ? 1.0 : 0.6)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
        
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashScreenView()
}
