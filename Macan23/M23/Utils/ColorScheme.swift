import SwiftUI

struct AppColors {
    static let primaryBackground = Color.white
    static let secondaryBackground = Color.white.opacity(0.95)
    static let cardBackground = Color.white.opacity(0.9)
    
    static let primaryText = Color(red: 0.2, green: 0.5, blue: 0.9)
    static let secondaryText = Color(red: 0.3, green: 0.5, blue: 0.8)
    static let placeholderText = Color(red: 0.5, green: 0.6, blue: 0.8)
    
    static let accent = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let accentLightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let purple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let pink = Color(red: 1.0, green: 0.4, blue: 0.6)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.98, green: 0.99, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.98, green: 0.99, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [accent, Color(red: 1.0, green: 0.9, blue: 0.3)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let blueGradient = LinearGradient(
        colors: [accentBlue, accentLightBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension View {
    func primaryBackground() -> some View {
        self.background(
            ZStack {
                AppColors.backgroundGradient.ignoresSafeArea()
                AnimatedBubblesBackground()
            }
        )
    }
    
    func cardStyle() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
            )
    }
}

struct AnimatedBubblesBackground: View {
    @State private var bubbles: [Bubble] = []
    @State private var timer: Timer?
    
    struct Bubble: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat
        let size: CGFloat
        let speed: CGFloat
        let opacity: Double
        let phase: Double
    }
    
    init() {
        let bubbleCount = 15
        var initialBubbles: [Bubble] = []
        
        for i in 0..<bubbleCount {
            initialBubbles.append(Bubble(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1),
                size: CGFloat.random(in: 40...120),
                speed: CGFloat.random(in: 0.3...0.8),
                opacity: Double.random(in: 0.1...0.3),
                phase: Double(i) * 0.5
            ))
        }
        
        _bubbles = State(initialValue: initialBubbles)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppColors.accentBlue.opacity(bubble.opacity),
                                    AppColors.accentLightBlue.opacity(bubble.opacity * 0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: bubble.size, height: bubble.size)
                        .position(
                            x: bubble.x * geometry.size.width,
                            y: bubble.y * geometry.size.height
                        )
                        .blur(radius: 2)
                }
            }
            .onAppear {
                startAnimation()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
        .ignoresSafeArea()
    }
    
    private func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
            let currentTime = Date().timeIntervalSince1970
            
            for index in bubbles.indices {
                bubbles[index].y -= bubbles[index].speed * 0.003
                
                if bubbles[index].y < -0.1 {
                    bubbles[index].y = 1.1
                    bubbles[index].x = CGFloat.random(in: 0...1)
                }
                
                bubbles[index].x += sin(currentTime * 0.5 + bubbles[index].phase) * 0.0005
            }
        }
    }
}
