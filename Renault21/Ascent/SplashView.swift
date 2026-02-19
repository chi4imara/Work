import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorTheme.primaryGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(ColorTheme.primaryAccent.opacity(0.1))
                        .frame(width: CGFloat.random(in: 50...150))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.3),
                            value: isAnimating
                        )
                }
            }
            
            VStack(spacing: 40) {
                ZStack {
                    Circle()
                        .stroke(ColorTheme.primaryAccent.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.3 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [ColorTheme.primaryAccent, ColorTheme.secondaryAccent, ColorTheme.primaryAccent],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(ColorTheme.primaryAccent)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                }
                
                Text("Preparing your fitness journey...")
                    .font(FontManager.playfairMedium(size: 18))
                    .foregroundColor(ColorTheme.secondaryText)
                    .opacity(isAnimating ? 1.0 : 0.6)
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
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
