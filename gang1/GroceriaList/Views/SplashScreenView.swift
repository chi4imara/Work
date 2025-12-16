import SwiftUI

struct SplashScreenView: View {
    @State private var animationAmount: CGFloat = 1.0
    @State private var orbPositions: [CGPoint] = []
    @State private var orbAnimations: [Bool] = []
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorManager.backgroundGradientStart,
                    ColorManager.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<8, id: \.self) { index in
                if index < orbPositions.count {
                    Circle()
                        .fill(ColorManager.orbColors[index % ColorManager.orbColors.count])
                        .frame(width: CGFloat.random(in: 20...60))
                        .position(orbPositions[index])
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: true),
                            value: orbAnimations[safe: index] ?? false
                        )
                }
            }
            
            VStack(spacing: 30) {
                ZStack {
                    Circle()
                        .stroke(ColorManager.primaryWhite.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    ColorManager.primaryYellow,
                                    ColorManager.primaryWhite
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(animationAmount * 360))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: animationAmount
                        )
                    
                    Circle()
                        .fill(ColorManager.primaryYellow.opacity(0.6))
                        .frame(width: 60, height: 60)
                        .scaleEffect(animationAmount)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: animationAmount
                        )
                    
                    Circle()
                        .fill(ColorManager.primaryWhite)
                        .frame(width: 20, height: 20)
                }
                
                Text("Loading...")
                    .font(FontManager.ubuntuMedium(24))
                    .foregroundColor(ColorManager.primaryText)
                    .opacity(animationAmount)
                    .animation(
                        Animation.easeInOut(duration: 1)
                            .repeatForever(autoreverses: true),
                        value: animationAmount
                    )
            }
        }
        .onAppear {
            setupOrbs()
            startAnimations()
        }
    }
    
    private func setupOrbs() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        orbPositions = (0..<8).map { _ in
            CGPoint(
                x: CGFloat.random(in: 50...(screenWidth - 50)),
                y: CGFloat.random(in: 100...(screenHeight - 100))
            )
        }
        
        orbAnimations = Array(repeating: false, count: 8)
    }
    
    private func startAnimations() {
        animationAmount = 1.2
        
        for i in 0..<orbAnimations.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                orbAnimations[i] = true
            }
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    SplashScreenView()
}
