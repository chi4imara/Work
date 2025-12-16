import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var orbPositions: [CGPoint] = []
    @State private var orbAnimations: [Bool] = Array(repeating: false, count: 6)
    
    let onComplete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(orbColor(for: index))
                        .frame(width: orbSize(for: index), height: orbSize(for: index))
                        .position(orbPosition(for: index, in: geometry))
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...5))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.3),
                            value: orbAnimations[index]
                        )
                }
                
                VStack(spacing: AppTheme.Spacing.xl) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(
                                AppTheme.Colors.primaryText.opacity(0.2),
                                lineWidth: 3
                            )
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(
                                AppTheme.Colors.primaryText,
                                style: StrokeStyle(lineWidth: 3, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(rotationAngle))
                            .animation(
                                Animation.linear(duration: 1.5)
                                    .repeatForever(autoreverses: false),
                                value: rotationAngle
                            )
                        
                        Circle()
                            .fill(AppTheme.Colors.primaryPurple)
                            .frame(width: 30, height: 30)
                            .scaleEffect(pulseScale)
                            .animation(
                                Animation.easeInOut(duration: 1.2)
                                    .repeatForever(autoreverses: true),
                                value: pulseScale
                            )
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onComplete()
            }
        }
    }
    
    private func startAnimations() {
        rotationAngle = 360
        
        pulseScale = 1.3
        
        for index in 0..<orbAnimations.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                orbAnimations[index].toggle()
            }
        }
    }
    
    private func orbColor(for index: Int) -> Color {
        switch index % 3 {
        case 0: return AppTheme.Colors.orb1
        case 1: return AppTheme.Colors.orb2
        default: return AppTheme.Colors.orb3
        }
    }
    
    private func orbSize(for index: Int) -> CGFloat {
        let sizes: [CGFloat] = [60, 40, 80, 35, 70, 45]
        return sizes[index % sizes.count]
    }
    
    private func orbPosition(for index: Int, in geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let basePositions: [CGPoint] = [
            CGPoint(x: width * 0.2, y: height * 0.3),
            CGPoint(x: width * 0.8, y: height * 0.2),
            CGPoint(x: width * 0.1, y: height * 0.7),
            CGPoint(x: width * 0.9, y: height * 0.8),
            CGPoint(x: width * 0.6, y: height * 0.1),
            CGPoint(x: width * 0.3, y: height * 0.9)
        ]
        
        let basePosition = basePositions[index % basePositions.count]
        
        let animationOffset: CGFloat = orbAnimations[index] ? 30 : -30
        return CGPoint(
            x: basePosition.x + (index % 2 == 0 ? animationOffset : -animationOffset),
            y: basePosition.y + (index % 3 == 0 ? animationOffset : -animationOffset)
        )
    }
}

#Preview {
    SplashScreen {
        print("Splash completed")
    }
}
