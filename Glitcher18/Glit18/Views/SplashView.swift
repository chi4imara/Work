import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            WaveShape()
                .fill(AppColors.lightPurple.opacity(0.3))
                .frame(height: 200)
                .offset(y: -100)
                .scaleEffect(x: isAnimating ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: isAnimating)
            
            WaveShape()
                .fill(AppColors.accentYellow.opacity(0.2))
                .frame(height: 150)
                .offset(y: 150)
                .scaleEffect(x: isAnimating ? 0.9 : 1.1)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: isAnimating)
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseScale)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.accentYellow, AppColors.brightYellow, AppColors.accentYellow.opacity(0.3)],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotation)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.primaryText.opacity(0.8))
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 60 + rotation * 0.5))
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(Double(index) * 0.1), value: isAnimating)
                    }
                    
                    Circle()
                        .fill(AppColors.accentGradient)
                        .frame(width: 16, height: 16)
                        .scaleEffect(scale)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scale)
                }
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(.playfairDisplay(size: 24, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .opacity(opacity)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: opacity)
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(AppColors.accentYellow)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.2 : 0.6)
                                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true).delay(Double(index) * 0.2), value: isAnimating)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        rotation = 360
        scale = 1.2
        opacity = 1.0
        pulseScale = 1.3
    }
}
