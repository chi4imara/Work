import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [AppColors.secondary, AppColors.white]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.secondary)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.white.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .offset(y: -50)
                            .rotationEffect(.degrees(Double(index) * 60 + rotationAngle * 0.5))
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Loading your daily companion...")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .opacity(isAnimating ? 1.0 : 0.7)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(AppColors.secondary)
                                .frame(width: 6, height: 6)
                                .scaleEffect(isAnimating ? 1.2 : 0.8)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
    }
}

#Preview {
    SplashView()
}
