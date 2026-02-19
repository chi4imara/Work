import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var pulseAnimation = false
    @State private var rotationAngle = 0.0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .opacity(pulseAnimation ? 0.5 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseAnimation
                        )
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.lightBlue, AppColors.orange]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ZStack {
                        ForEach(0..<8) { index in
                            Rectangle()
                                .fill(AppColors.orange)
                                .frame(width: 3, height: 15)
                                .offset(y: -20)
                                .rotationEffect(.degrees(Double(index) * 45))
                        }
                    }
                    .rotationEffect(.degrees(-rotationAngle * 0.5))
                    .animation(
                        Animation.linear(duration: 4.0)
                            .repeatForever(autoreverses: false),
                        value: rotationAngle
                    )
                    
                    Circle()
                        .fill(AppColors.white)
                        .frame(width: 8, height: 8)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.0)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(AppColors.lightBlue)
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimating = true
            }
            pulseAnimation = true
            rotationAngle = 360
        }
    }
}
