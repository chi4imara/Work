import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.6
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.appPrimary.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    Color.appPrimary,
                                    Color.appYellow,
                                    Color.appLightBlue
                                ]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.appPrimary,
                                        Color.appDarkBlue
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                            .scaleEffect(scale)
                            .animation(
                                Animation.easeInOut(duration: 1.2)
                                    .repeatForever(autoreverses: true),
                                value: scale
                            )
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .opacity(opacity)
                            .animation(
                                Animation.easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true),
                                value: opacity
                            )
                    }
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.appPrimary)
                            .frame(width: 8, height: 8)
                            .scaleEffect(scale)
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: scale
                            )
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
    
    private func startAnimations() {
        rotationAngle = 360
        scale = 1.2
        opacity = 1.0
        pulseScale = 1.3
    }
}

#Preview {
    SplashScreen()
}
