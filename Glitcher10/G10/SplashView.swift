import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [ColorManager.orange, ColorManager.lightBlue, ColorManager.orange],
                                center: .center
                            ),
                            lineWidth: 6
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(ColorManager.white)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Text("Loading...")
                    .font(FontManager.ubuntu(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.white)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
    }
}
