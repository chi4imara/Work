import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @Binding var showSplash: Bool
    
    var body: some View {
        ZStack {
            AppColors.gradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(2 - pulseScale)
                    
                    ForEach(0..<8) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(AppColors.accent)
                            .frame(width: 4, height: 20)
                            .offset(y: -40)
                            .rotationEffect(.degrees(Double(index) * 45 + rotationAngle))
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(
                                .easeInOut(duration: 0.8)
                                .delay(Double(index) * 0.1)
                                .repeatForever(autoreverses: true),
                                value: isAnimating
                            )
                    }
                    
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 12, height: 12)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
        
        withAnimation(.easeInOut(duration: 0.5)) {
            isAnimating = true
        }
    }
}
