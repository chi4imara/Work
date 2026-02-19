import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale = 0.8
    @State private var opacity = 0.5
    @State private var rotationAngle = 0.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.theme.lightBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [Color.theme.lightBlue, Color.theme.lightBlue.opacity(0.6), Color.theme.lightBlue]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(Color.theme.lightBlue.opacity(0.6))
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                    
                    Circle()
                        .fill(Color.theme.lightBlue)
                        .frame(width: 8, height: 8)
                }
                .scaleEffect(isAnimating ? 1.1 : 0.9)
                .animation(
                    Animation.easeInOut(duration: 0.8)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation {
            isAnimating = true
            rotationAngle = 360
            scale = 1.2
            opacity = 0.8
        }
    }
}

#Preview {
    SplashScreen()
}
