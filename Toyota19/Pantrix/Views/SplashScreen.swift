import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.appOrange.opacity(0.3), lineWidth: 3)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [Color.appOrange, Color.appLightBlue, Color.appOrange],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                    
                    ZStack {
                        Circle()
                            .fill(Color.appOrange.opacity(0.8))
                            .frame(width: 40, height: 40)
                            .scaleEffect(scale)
                        
                        Image(systemName: "fork.knife")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.appWhite)
                            .scaleEffect(scale)
                    }
                }
                .opacity(opacity)
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.appOrange)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.2 : 0.6)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.top, 20)
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
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
        }
        
        withAnimation(
            Animation.linear(duration: 2.0)
                .repeatForever(autoreverses: false)
        ) {
            rotation = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            scale = 1.1
        }
        
        withAnimation(
            Animation.easeInOut(duration: 2.0)
        ) {
            opacity = 1.0
        }
    }
}
