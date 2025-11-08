import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var ringScale: CGFloat = 0.5
    @State private var ringOpacity: Double = 1.0
    @State private var glowIntensity: Double = 0.3
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.pureWhite.opacity(ringOpacity), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(ringScale)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: ringScale
                        )
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            AppColors.accentYellow,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(AppColors.pureWhite.opacity(0.8))
                        .frame(width: 40, height: 40)
                        .scaleEffect(pulseScale)
                        .shadow(color: AppColors.pureWhite, radius: glowIntensity * 20)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: 12, height: 12)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Loading your experiences...")
                        .font(FontManager.callout)
                        .foregroundColor(AppColors.pureWhite.opacity(0.8))
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(AppColors.pureWhite)
                                .frame(width: 6, height: 6)
                                .scaleEffect(pulseScale)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                    value: pulseScale
                                )
                        }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            print("🎬 SplashScreen appeared")
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                print("⏰ SplashScreen timeout - calling onComplete")
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation {
            rotationAngle = 360
        }
        
        withAnimation {
            pulseScale = 1.2
        }
        
        withAnimation {
            ringScale = 1.2
            ringOpacity = 0.3
        }
        
        withAnimation {
            glowIntensity = 0.8
        }
    }
}
