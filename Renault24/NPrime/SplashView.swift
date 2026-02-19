import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.secondary.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.secondary, AppColors.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.cardBackground)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "figure.strengthtraining.functional")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppColors.secondary)
                    }
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: scale
                    )
                }
                
                VStack(spacing: 8) {
                    Text("FitMaster")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.text)
                        .opacity(opacity)
                    
                    Text("Your Personal Fitness Coach")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                        .opacity(opacity * 0.8)
                }
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: opacity
                )
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation {
            rotationAngle = 360
        }
        
        withAnimation {
            scale = 1.2
        }
        
        withAnimation {
            opacity = 1.0
        }
        
        withAnimation {
            pulseScale = 1.3
        }
    }
}

#Preview {
    SplashView()
}
