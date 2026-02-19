import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 2.0)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryYellow, Color.primaryBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: rotation
                        )
                    
                    Circle()
                        .fill(Color.primaryYellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation {
            rotation = 360
        }
        
        withAnimation {
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation {
            pulseScale = 1.3
        }
    }
}

