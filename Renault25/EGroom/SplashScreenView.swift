import SwiftUI

struct SplashScreenView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @State private var rotationAngle: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var pulseScale: CGFloat = 1.0
    @Binding var isLoading: Bool
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.primaryOrange.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [Color.primaryOrange, Color.lightBlue, Color.primaryOrange],
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
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.primaryOrange, Color.primaryOrange.opacity(0.3)],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                
                Text("Loading...")
                    .font(FontManager.playfairDisplay(.medium, size: 18))
                    .foregroundColor(.primaryWhite)
                    .opacity(opacity)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
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
        withAnimation {
            rotationAngle = 360
        }
        
        withAnimation {
            scale = 1.2
        }
        
        withAnimation {
            opacity = 1.0
        }
        
        withAnimation {
            pulseScale = 1.3
        }
    }
}
