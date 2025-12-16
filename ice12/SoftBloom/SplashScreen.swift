import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.accentBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [Color.primaryPurple, Color.accentBlue, Color.accentYellow],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(Color.accentYellow)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    ForEach(0..<6, id: \.self) { index in
                        Circle()
                            .fill(Color.softGreen.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .offset(
                                x: cos(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 50,
                                y: sin(Double(index) * .pi / 3 + rotationAngle * .pi / 180) * 50
                            )
                            .opacity(isAnimating ? 1 : 0.3)
                    }
                }
                
                Spacer()
                
                Text("Loading your gratitude journey...")
                    .font(.playfairDisplay(size: 18, weight: .medium))
                    .foregroundColor(.accentBlue)
                    .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            isAnimating = true
        }
    }
}
