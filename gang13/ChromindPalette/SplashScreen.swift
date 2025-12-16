import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    @StateObject private var colorTheme = ColorTheme.shared
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(colorTheme.primaryWhite.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [
                                    colorTheme.primaryPurple,
                                    colorTheme.accentPurple,
                                    colorTheme.primaryWhite,
                                    colorTheme.primaryPurple
                                ],
                                center: .center
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(colorTheme.moodColors[index].color)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 45 + rotationAngle * 0.5))
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                    }
                    
                    Circle()
                        .fill(colorTheme.primaryWhite)
                        .frame(width: 12, height: 12)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Spacer()
                
                Text("Loading your colors...")
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite)
                    .opacity(opacity)
            }
            .padding()
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
        }
        
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}


