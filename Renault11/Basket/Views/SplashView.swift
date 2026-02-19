import SwiftUI

struct SplashView: View {
    @State private var isLoading = true
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.6
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.theme.primaryWhite.opacity(0.3), lineWidth: 4)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.theme.primaryYellow, Color.theme.lightYellow]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
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
                    
                    Circle()
                        .fill(Color.theme.primaryYellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                
                Text("Loading your shopping experience...")
                    .font(FontManager.playfairRegular(size: 16))
                    .foregroundColor(Color.theme.primaryWhite)
                    .opacity(opacity)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: opacity
                    )
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
        rotationAngle = 360
        scale = 1.2
        opacity = 1.0
    }
}

#Preview {
    SplashView()
}
