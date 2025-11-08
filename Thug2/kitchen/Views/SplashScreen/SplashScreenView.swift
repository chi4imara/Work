import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 50) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryWhite.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(opacity)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.primaryOrange, AppColors.accentPurple, AppColors.primaryOrange],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.primaryWhite)
                            .frame(width: 6, height: 6)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 60 + rotationAngle * 0.5))
                            .opacity(isAnimating ? 1.0 : 0.3)
                    }
                    
                    Image(systemName: "house.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(AppColors.primaryOrange)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Loading your ideas...")
                        .font(AppFonts.subheadline())
                        .foregroundColor(AppColors.primaryText)
                        .opacity(isAnimating ? 1.0 : 0.7)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(AppColors.primaryOrange)
                                .frame(width: 8, height: 8)
                                .opacity(isAnimating ? 1.0 : 0.3)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                }
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
            opacity = 0.8
        }
        
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashScreenView()
}
