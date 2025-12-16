import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(Color.theme.primaryPurple.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [Color.theme.primaryBlue, Color.theme.primaryPurple, Color.theme.primaryYellow, Color.theme.primaryBlue],
                                center: .center
                            ),
                            lineWidth: 6
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(Color.theme.primaryYellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Image(systemName: craftIcons[index])
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.theme.primaryBlue.opacity(0.6))
                            .offset(
                                x: cos(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 50,
                                y: sin(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 50
                            )
                    }
                }
                
                Text("Loading your creative space...")
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .opacity(opacity)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private let craftIcons = [
        "scissors",
        "paintbrush.fill",
        "pencil.circle",
        "pencil.and.scribble",
        "square.and.pencil",
        "heart.fill"
    ]
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}

#Preview {
    SplashView()
}
