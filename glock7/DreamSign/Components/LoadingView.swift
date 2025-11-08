import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .stroke(AppColors.yellow.opacity(0.6), lineWidth: 3)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 3.0)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                    
                    Circle()
                        .fill(AppColors.yellow)
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(isAnimating ? -360 : 0))
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                    
                    Circle()
                        .fill(AppColors.primaryText)
                        .frame(width: 8, height: 8)
                }
                
                Text("Loading...")
                    .font(AppFonts.medium(18))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(isAnimating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
            pulseScale = 1.3
        }
    }
}

#Preview {
    LoadingView()
}
