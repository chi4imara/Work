import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var appState: AppState
    @State private var animationProgress: CGFloat = 0
    @State private var pulseScale: CGFloat = 1
    @State private var rotationAngle: Double = 0
    @State private var showSecondaryAnimation = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                    
                    ForEach(0..<8) { index in
                        Circle()
                            .fill(AppColors.yellow)
                            .frame(width: 12, height: 12)
                            .offset(y: -40)
                            .rotationEffect(.degrees(Double(index) * 45 + rotationAngle))
                            .opacity(showSecondaryAnimation ? 1 : 0)
                    }
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.pink)
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(rotationAngle * 2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(AppColors.yellow)
                                .frame(width: 20, height: 20)
                                .rotationEffect(.degrees(-rotationAngle * 3))
                        )
                    
                    Circle()
                        .trim(from: 0, to: animationProgress)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.yellow, AppColors.pink, AppColors.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                }
                
                HStack(spacing: 4) {
                    ForEach(Array("Loading...".enumerated()), id: \.offset) { index, character in
                        Text(String(character))
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .opacity(animationProgress > CGFloat(index) / 10 ? 1 : 0.3)
                            .animation(.easeInOut(duration: 0.1).delay(Double(index) * 0.1), value: animationProgress)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
        
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 2.5)) {
            animationProgress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showSecondaryAnimation = true
            }
        }
    }
}
