import SwiftUI

struct BackgroundView: View {
    @State private var animateStars = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<20, id: \.self) { index in
                StarView()
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(animateStars ? 0.3 : 0.8)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animateStars
                    )
            }
        }
        .onAppear {
            animateStars = true
        }
    }
}

struct StarView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        Image(systemName: "star.fill")
            .foregroundColor(AppColors.starColor)
            .font(.system(size: CGFloat.random(in: 8...16)))
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(
                    Animation.linear(duration: Double.random(in: 10...20))
                        .repeatForever(autoreverses: false)
                ) {
                    rotation = 360
                }
            }
    }
}

#Preview {
    BackgroundView()
}
