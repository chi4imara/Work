import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var loadingProgress: CGFloat = 0.0
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: CGFloat.random(in: -400...400)
                    )
                    .scaleEffect(pulseScale * (0.5 + Double(index) * 0.1))
                    .animation(
                        Animation.easeInOut(duration: 2.0 + Double(index) * 0.3)
                            .repeatForever(autoreverses: true),
                        value: pulseScale
                    )
            }
            
            VStack(spacing: 50) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: loadingProgress)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primaryBlue, Color.white],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.white.opacity(0.8), Color.white.opacity(0.2)],
                                center: .center,
                                startRadius: 10,
                                endRadius: 40
                            )
                        )
                        .frame(width: 60, height: 60)
                        .scaleEffect(pulseScale)
                    
                    Circle()
                        .fill(AppColors.accentBlue)
                        .frame(width: 20, height: 20)
                        .scaleEffect(pulseScale * 0.8)
                }
                .opacity(opacity)
                
                VStack(spacing: 10) {
                    Text("Loading...")
                        .font(AppFonts.title2())
                        .foregroundColor(AppColors.primaryText)
                        .opacity(opacity)
                    
                    Text("Preparing your medication tracker")
                        .font(AppFonts.callout())
                        .foregroundColor(AppColors.secondaryText)
                        .opacity(opacity * 0.8)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            startLoading()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.5)) {
            opacity = 1.0
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.2
        }
        
        withAnimation(
            Animation.linear(duration: 3.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
    }
    
    private func startLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.1)) {
                loadingProgress += 0.02
            }
            
            if loadingProgress >= 1.0 {
                timer.invalidate()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        opacity = 0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    }
                }
            }
        }
    }
}
