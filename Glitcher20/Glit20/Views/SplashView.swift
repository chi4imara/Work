import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    
    var body: some View {
        ZStack {
            AppColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.primaryYellow.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryYellow, Color.secondaryPink]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(Color.primaryYellow.opacity(0.6))
                        .frame(width: 60, height: 60)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        rotationAngle = 360
        scale = 1.2
        opacity = 0.8
    }
}

#Preview {
    SplashView()
}
