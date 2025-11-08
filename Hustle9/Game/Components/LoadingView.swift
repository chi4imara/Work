import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    ForEach(0..<8) { index in
                        Circle()
                            .fill(AppColors.accent)
                            .frame(width: 12, height: 12)
                            .offset(y: -40)
                            .rotationEffect(.degrees(Double(index) * 45))
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .opacity(isAnimating ? 0.3 : 1.0)
                            .animation(
                                Animation.linear(duration: 2.0)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.1),
                                value: isAnimating
                            )
                    }
                    
                    Image(systemName: "gamecontroller.fill")
                        .font(.system(size: 30))
                        .foregroundColor(AppColors.primaryText)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(
                            Animation.linear(duration: 4.0)
                                .repeatForever(autoreverses: false),
                            value: isAnimating
                        )
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            isAnimating = true
            pulseScale = 1.2
        }
    }
}

#Preview {
    LoadingView()
}
