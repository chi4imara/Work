import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            Color.theme.accentGradient,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(Color.theme.orange)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Text("Loading...")
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.2
        }
        
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

#Preview {
    SplashScreen()
}
