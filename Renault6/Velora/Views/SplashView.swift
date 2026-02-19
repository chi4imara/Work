import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryAccent.opacity(0.5), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(opacity)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.primaryAccent, AppColors.primaryAccent.opacity(0.4)],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.primaryAccent.opacity(0.9))
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.primaryAccent.opacity(0.7))
                            .frame(width: 6, height: 6)
                            .offset(
                                x: cos(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 50,
                                y: sin(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 50
                            )
                            .opacity(isAnimating ? 1.0 : 0.3)
                    }
                }
                .onAppear {
                    startAnimations()
                }
                
                Spacer()
                
                Text("Loading your harmony...")
                    .font(.ubuntu(16, weight: .light))
                    .foregroundColor(AppColors.primaryText.opacity(0.8))
                    .opacity(isAnimating ? 1.0 : 0.5)
                
                Spacer()
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
            opacity = 0.8
        }
        
        withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashView()
}
