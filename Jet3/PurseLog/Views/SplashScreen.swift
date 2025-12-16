import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [AppColors.primaryPurple, AppColors.primaryYellow, AppColors.primaryPurple]),
                                center: .center
                            ),
                            lineWidth: 6
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.primaryYellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 4, height: 4)
                            .offset(
                                x: cos(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 50,
                                y: sin(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 50
                            )
                            .opacity(isAnimating ? 1.0 : 0.3)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("Loading your collection...")
                        .font(FontManager.ubuntu(.medium, size: 18))
                        .foregroundColor(AppColors.primaryText)
                        .opacity(isAnimating ? 1.0 : 0.6)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(AppColors.primaryYellow)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(Animation.linear(duration: 3.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
