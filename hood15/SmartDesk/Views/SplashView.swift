import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotation = 0.0
    @State private var scale = 1.0
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 50) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue, lineWidth: 4)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.primaryBlue, AppColors.secondaryBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 1.5).repeatForever(autoreverses: false),
                            value: rotation
                        )
                    
                    Circle()
                        .fill(AppColors.primaryBlue)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .animation(
                            Animation.easeInOut(duration: 1).repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                .opacity(opacity)
                .animation(.easeIn(duration: 0.5), value: opacity)
                
                Spacer()
            }
        }
        .onAppear {
            opacity = 1.0
            rotation = 360
            scale = 1.3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    opacity = 0.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
}
