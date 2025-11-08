import SwiftUI

struct SplashScreen: View {
    @State private var isLoading = true
    @State private var scale = 0.8
    @State private var opacity = 0.5
    @State private var rotation = 0.0
    @State private var pulseScale = 1.0
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.pureWhite.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [Color.pureWhite, Color.lightBlue, Color.pureWhite]),
                                center: .center
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotation))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotation
                        )
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(.pureWhite)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                
                Text("Loading...")
                    .font(.customBody())
                    .foregroundColor(.pureWhite)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation {
            scale = 1.2
            opacity = 1.0
            rotation = 360
            pulseScale = 1.3
        }
    }
}

#Preview {
    SplashScreen()
}

