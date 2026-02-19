import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.accentYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            ColorManager.accentYellow,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(ColorManager.accentYellow.opacity(0.8))
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(ColorManager.textWhite)
                        .frame(width: 12, height: 12)
                }
                
                Text("Loading...")
                    .font(FontManager.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.textWhite)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
    }
}

#Preview {
    SplashScreenView()
}
