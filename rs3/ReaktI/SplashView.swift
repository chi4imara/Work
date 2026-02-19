import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseAnimation = false
    @State private var rotationAnimation = false
    @State private var scaleAnimation = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.primaryBlue.opacity(0.8),
                    AppColors.primaryYellow.opacity(0.6),
                    AppColors.accentPurple.opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 50...150))
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.3 : 1.0)
                        .opacity(pulseAnimation ? 0.0 : 1.0)
                        .animation(
                            Animation.easeOut(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: pulseAnimation
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white, Color.white.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAnimation ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotationAnimation
                        )
                    
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 40, height: 40)
                            .scaleEffect(scaleAnimation ? 1.1 : 0.9)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true),
                                value: scaleAnimation
                            )
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.primaryBlue)
                            .scaleEffect(scaleAnimation ? 1.2 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true)
                                    .delay(0.2),
                                value: scaleAnimation
                            )
                    }
                }
                
                VStack(spacing: 8) {
                    Text("Loading your reactions...")
                        .font(.ibmPlexMono(16, weight: .medium))
                        .foregroundColor(.white)
                        .opacity(isAnimating ? 1.0 : 0.7)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
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
            isAnimating = true
            pulseAnimation = true
            rotationAnimation = true
            scaleAnimation = true
        }
    }
}
