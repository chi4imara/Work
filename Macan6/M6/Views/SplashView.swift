import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.yellow, AppColors.brightYellow]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                    
                    Circle()
                        .fill(AppColors.yellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                .onAppear {
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
                        rotation = 360
                    }
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(isAnimating ? 1.0 : 0.5)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SplashView()
}
