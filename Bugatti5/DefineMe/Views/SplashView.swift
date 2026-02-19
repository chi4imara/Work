import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(2.0 - pulseScale)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.accentYellow, AppColors.brightYellow, AppColors.accentYellow.opacity(0.3)],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.brightYellow)
                        .frame(width: 16, height: 16)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                Spacer()
                
                Text("Loading...")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
        
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashView()
}
