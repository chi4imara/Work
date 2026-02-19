import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotation = 0.0
    @State private var scale = 0.8
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            AnimatedBubblesBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.accent.opacity(0.3), lineWidth: 4)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.accent, AppColors.accent.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: rotation
                        )
                    
                    Circle()
                        .fill(AppColors.accent.opacity(0.8))
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                .opacity(opacity)
                .animation(.easeInOut(duration: 0.8), value: opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    opacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 0.8)) {
            opacity = 1.0
        }
        
        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            rotation = 360
        }
        
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.2
        }
    }
}
