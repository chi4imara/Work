import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.background,
                    AppColors.surface,
                    Color(red: 0.9, green: 0.95, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...60))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .opacity(isAnimating ? 0.8 : 0.3)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: AppSpacing.xl) {
                ZStack {
                    Circle()
                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(2 - pulseScale)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    RoundedRectangle(cornerRadius: isAnimating ? 25 : 8)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.secondary, AppColors.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: isAnimating ? 50 : 30,
                            height: isAnimating ? 50 : 30
                        )
                        .rotationEffect(.degrees(rotationAngle * 0.5))
                        .opacity(opacity)
                }
                
                VStack(spacing: AppSpacing.sm) {
                    Text("Preparing your wellness journey...")
                        .font(AppFonts.playfairMedium(size: 18))
                        .foregroundColor(AppColors.textPrimary)
                        .opacity(isAnimating ? 1 : 0)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(AppColors.primary)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .opacity(isAnimating ? 1.0 : 0.3)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.0)) {
            isAnimating = true
        }
        
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.3
        }
        
        withAnimation(
            Animation.linear(duration: 3.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            opacity = 1.0
        }
    }
}

#Preview {
    SplashView()
}
