import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var pulseAnimation = false
    @State private var rotationAngle = 0.0
    
    var body: some View {
        ZStack {
            ColorManager.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .opacity(pulseAnimation ? 0.5 : 1.0)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [ColorManager.orange, ColorManager.lightBlue]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Image(systemName: "flame.fill")
                        .font(.system(size: 30))
                        .foregroundColor(ColorManager.orange)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                }
                
                Text("Loading...")
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .opacity(isAnimating ? 1.0 : 0.7)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashScreen()
}
