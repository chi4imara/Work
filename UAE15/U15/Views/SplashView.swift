import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorManager.shared.primaryBackground
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorManager.shared.accentBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    ColorManager.shared.accentOrange,
                                    ColorManager.shared.accentBlue,
                                    ColorManager.shared.accentOrange
                                ]),
                                center: .center
                            ),
                            lineWidth: 6
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(ColorManager.shared.accentBlue)
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Image(systemName: "scissors")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorManager.shared.primaryText)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(FontManager.playfairMedium(size: 18))
                    .foregroundColor(ColorManager.shared.secondaryText)
                    .opacity(isAnimating ? 1.0 : 0.6)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
        
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}
