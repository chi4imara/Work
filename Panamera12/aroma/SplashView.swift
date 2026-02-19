import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0.3
    
    var body: some View {
        ZStack {
            AppColors.splashGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                ZStack {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(Color.appPrimaryYellow.opacity(0.3), lineWidth: 2)
                            .frame(width: 120 + CGFloat(index * 30), height: 120 + CGFloat(index * 30))
                            .scaleEffect(pulseScale + CGFloat(index) * 0.1)
                            .opacity(opacity - Double(index) * 0.1)
                    }
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.appPrimaryYellow, Color.orange, Color.appPrimaryBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 3)
                        )
                        .rotationEffect(.degrees(rotationAngle))
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                }
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color.appPrimaryYellow)
                            .frame(width: 12, height: 12)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
            opacity = 0.8
        }
        
        withAnimation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}

#Preview {
    SplashView()
}
