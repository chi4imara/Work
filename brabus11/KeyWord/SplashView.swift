import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [ColorManager.primaryBlue, ColorManager.primaryYellow],
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
                    
                    ForEach(0..<6) { index in
                        Circle()
                            .fill(ColorManager.accentPurple)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 60 + rotationAngle * 0.5))
                            .opacity(isAnimating ? 0.3 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 0.8)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                value: isAnimating
                            )
                            .id(index)
                    }
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    ColorManager.primaryYellow.opacity(0.6),
                                    ColorManager.primaryYellow.opacity(0.0)
                                ],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                LoadingTextView()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        pulseScale = 1.3
        rotationAngle = 360
    }
}

struct LoadingTextView: View {
    @State private var displayedText = ""
    private let fullText = "Loading your words..."
    
    var body: some View {
        Text(displayedText)
            .font(.playfairDisplay(18, weight: .medium))
            .foregroundColor(ColorManager.textBlue)
            .onAppear {
                typewriterEffect()
            }
    }
    
    private func typewriterEffect() {
        displayedText = ""
        for (index, character) in fullText.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                displayedText += String(character)
            }
        }
    }
}

#Preview {
    SplashView()
}
