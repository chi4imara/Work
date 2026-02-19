import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let yellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let brightYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color.black
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, lightBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let pink = Color(red: 1.0, green: 0.6, blue: 0.8)
    static let purple = Color(red: 0.7, green: 0.5, blue: 1.0)
    static let green = Color(red: 0.4, green: 0.9, blue: 0.6)
    static let orange = Color(red: 1.0, green: 0.7, blue: 0.3)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
}

struct AnimatedBackground: View {
    @State private var bubbles: [Bubble] = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(bubbles) { bubble in
                Circle()
                    .fill(Color.white.opacity(bubble.opacity))
                    .frame(width: bubble.size, height: bubble.size)
                    .position(bubble.position)
                    .animation(.linear(duration: bubble.duration).repeatForever(autoreverses: false), value: bubble.position)
            }
        }
        .onAppear {
            createBubbles()
        }
    }
    
    private func createBubbles() {
        bubbles = (0..<15).map { _ in
            Bubble(
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 50
                ),
                size: CGFloat.random(in: 10...40),
                opacity: Double.random(in: 0.1...0.3),
                duration: Double.random(in: 8...15)
            )
        }
    }
    
    private func startBubbleAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for index in bubbles.indices {
                bubbles[index].position.y -= CGFloat.random(in: 0.5...2.0)
                bubbles[index].position.x += CGFloat.random(in: -1...1)
                
                if bubbles[index].position.y < -50 {
                    bubbles[index].position = CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: UIScreen.main.bounds.height + 50
                    )
                }
            }
        }
    }
}

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let opacity: Double
    let duration: Double
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(18, weight: .medium))
            .foregroundColor(AppColors.accentText)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(AppColors.yellow)
            .cornerRadius(25)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
            .background(AppColors.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .cornerRadius(16)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
