import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                FloatingParticle(index: index)
            }
        }
    }
}

struct FloatingParticle: View {
    let index: Int
    @State private var moveX: CGFloat = 0
    @State private var moveY: CGFloat = 0
    @State private var opacity: Double = 0.3
    @State private var scale: CGFloat = 1.0
    
    private var size: CGFloat {
        CGFloat.random(in: 4...12)
    }
    
    private var animationDuration: Double {
        Double.random(in: 3...8)
    }
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(opacity))
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .offset(x: moveX, y: moveY)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        moveX = CGFloat.random(in: -screenWidth/2...screenWidth/2)
        moveY = CGFloat.random(in: -screenHeight/2...screenHeight/2)
        
        withAnimation(
            Animation.easeInOut(duration: animationDuration)
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.2)
        ) {
            moveX = CGFloat.random(in: -screenWidth/2...screenWidth/2)
            moveY = CGFloat.random(in: -screenHeight/2...screenHeight/2)
        }
        
        withAnimation(
            Animation.easeInOut(duration: animationDuration * 0.7)
                .repeatForever(autoreverses: true)
                .delay(Double(index) * 0.1)
        ) {
            opacity = Double.random(in: 0.1...0.6)
            scale = CGFloat.random(in: 0.5...1.5)
        }
    }
}

#Preview {
    AnimatedBackground()
}
