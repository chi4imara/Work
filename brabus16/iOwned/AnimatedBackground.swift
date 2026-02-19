import SwiftUI

struct AnimatedBackground: View {
    let particleCount = 8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ForEach(0..<particleCount, id: \.self) { index in
                    ParticleView(
                        index: index,
                        screenSize: geometry.size
                    )
                }
            }
        }
    }
}

struct ParticleView: View {
    let index: Int
    let screenSize: CGSize
    
    @State private var position: CGPoint = .zero
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 0.2
    
    private let size: CGFloat
    private let duration: Double
    private let delay: Double
    
    init(index: Int, screenSize: CGSize) {
        self.index = index
        self.screenSize = screenSize
        self.size = CGFloat.random(in: 12...20)
        self.duration = Double.random(in: 8...12)
        self.delay = Double(index) * 0.3
    }
    
    var body: some View {
        Circle()
            .fill(ColorTheme.primaryBlue.opacity(opacity))
            .frame(width: size, height: size)
            .scaleEffect(scale)
            .position(position)
            .onAppear {
                setupPosition()
                startAnimations()
            }
    }
    
    private func setupPosition() {
        position = CGPoint(
            x: CGFloat.random(in: 0...screenSize.width),
            y: CGFloat.random(in: 0...screenSize.height)
        )
    }
    
    private func startAnimations() {
        withAnimation(
            .easeInOut(duration: duration)
            .repeatForever(autoreverses: true)
            .delay(delay)
        ) {
            scale = 1.3
            opacity = 0.4
        }
    }
}

#Preview {
    AnimatedBackground()
}
