import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryBlue.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primaryBlue, AppColors.primaryYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [AppColors.primaryYellow, AppColors.primaryBlue.opacity(0.6)],
                                center: .center,
                                startRadius: 10,
                                endRadius: 30
                            )
                        )
                        .frame(width: 60, height: 60)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: scale
                        )
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.backgroundWhite)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 60))
                            .opacity(opacity)
                            .animation(
                                Animation.easeInOut(duration: 0.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                value: opacity
                            )
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 12, height: 12)
                            .scaleEffect(scale)
                            .animation(
                                Animation.easeInOut(duration: 0.8)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: scale
                            )
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            rotationAngle = 360
            scale = 1.3
            opacity = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
