import SwiftUI

struct SplashScreenView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryWhite.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(opacity)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primaryWhite, AppColors.accentPurple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(AppColors.primaryWhite)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 45 + rotationAngle * 2))
                            .opacity(sin(rotationAngle * .pi / 180 + Double(index) * .pi / 4) * 0.5 + 0.5)
                    }
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.primaryWhite, AppColors.accentPurple.opacity(0.8)],
                                center: .center,
                                startRadius: 2,
                                endRadius: 15
                            )
                        )
                        .frame(width: 20, height: 20)
                        .scaleEffect(pulseScale * 0.8)
                }
                .opacity(opacity)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Loading")
                        .font(FontManager.title3)
                        .foregroundColor(AppColors.primaryWhite)
                    
                    HStack(spacing: 2) {
                        ForEach(0..<3, id: \.self) { index in
                            Text(".")
                                .font(FontManager.title3)
                                .foregroundColor(AppColors.primaryWhite)
                                .opacity(sin(rotationAngle * .pi / 180 + Double(index) * .pi / 2) * 0.5 + 0.5)
                        }
                    }
                }
                .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    opacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.8)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
    }
}
