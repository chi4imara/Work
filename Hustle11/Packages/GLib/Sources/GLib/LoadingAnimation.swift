import SwiftUI

struct AppColors {
    
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let secondaryBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let accentBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let background = primaryBlue
    static let cardBackground = Color.white.opacity(0.15)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let elementBackground = Color.white.opacity(0.2)
    static let elementBorder = Color.white.opacity(0.3)
    static let buttonBackground = Color.white.opacity(0.25)
    static let buttonPressed = Color.white.opacity(0.4)
    
    static let workColor = Color.orange
    static let hobbyColor = Color.purple
    static let travelColor = Color.green
    static let familyColor = Color.pink
    static let otherColor = Color.gray
    
    static let tagColors: [Color] = [
        .blue, .purple, .pink, .red, .orange, .yellow, .green, .mint, .teal, .cyan
    ]
    
    static let wheelColors: [Color] = [
        Color(red: 0.2, green: 0.6, blue: 1.0),
        Color(red: 0.2, green: 0.8, blue: 0.4),
        Color(red: 1.0, green: 0.6, blue: 0.2),
        Color(red: 0.8, green: 0.4, blue: 1.0),
        Color(red: 1.0, green: 0.4, blue: 0.6),
        Color(red: 1.0, green: 0.3, blue: 0.3),
        Color(red: 0.2, green: 0.8, blue: 0.8),
        Color(red: 0.4, green: 0.9, blue: 0.7),
        Color(red: 0.5, green: 0.4, blue: 1.0),
        Color(red: 0.8, green: 0.6, blue: 0.4)
    ]
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let backgroundGradient = LinearGradient(
        colors: [
            primaryBlue,
            secondaryBlue.opacity(0.8),
            primaryBlue.opacity(0.9)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.2),
            Color.white.opacity(0.1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.3),
            Color.white.opacity(0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static func randomTagColor() -> Color {
        return tagColors.randomElement() ?? .blue
    }
}

struct FontManager {
    
    enum NunitoFont: String, CaseIterable {
        case regular = "Nunito-Regular"
        case medium = "Nunito-Medium"
        case semiBold = "Nunito-SemiBold"
        case bold = "Nunito-Bold"
    }
    
    enum FontSize: CGFloat {
        case caption = 12
        case body = 16
        case title3 = 18
        case title2 = 20
        case title1 = 24
        case largeTitle = 28
        case extraLarge = 32
    }
    
    static func nunito(_ weight: NunitoFont, size: FontSize) -> Font {
        return Font.custom(weight.rawValue, size: size.rawValue)
    }
    
    static func nunito(_ weight: NunitoFont, size: CGFloat) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
    
    static let largeTitle = nunito(.bold, size: .largeTitle)
    static let title1 = nunito(.bold, size: .title1)
    static let title2 = nunito(.semiBold, size: .title2)
    static let title3 = nunito(.semiBold, size: .title3)
    static let headline = nunito(.semiBold, size: .body)
    static let body = nunito(.regular, size: .body)
    static let callout = nunito(.medium, size: .body)
    static let subheadline = nunito(.medium, size: 14)
    static let footnote = nunito(.regular, size: 13)
    static let caption = nunito(.regular, size: .caption)
    
    static func registerFonts() {
        for font in NunitoFont.allCases {
            if let url = Bundle.main.url(forResource: font.rawValue, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
}

extension Font {
    static func nunito(_ weight: FontManager.NunitoFont, size: FontManager.FontSize) -> Font {
        return FontManager.nunito(weight, size: size)
    }
    
    static func nunito(_ weight: FontManager.NunitoFont, size: CGFloat) -> Font {
        return FontManager.nunito(weight, size: size)
    }
}


struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<15, id: \.self) { index in
                FloatingCircle(
                    delay: Double(index) * 0.5,
                    duration: Double.random(in: 8...15)
                )
            }
        }
    }
}

struct FloatingCircle: View {
    let delay: Double
    let duration: Double
    
    @State private var moveUp = false
    @State private var moveRight = false
    @State private var opacity: Double = 0
    
    private let size = CGFloat.random(in: 8...25)
    private let startX = CGFloat.random(in: -50...400)
    private let startY: CGFloat = 900
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.1))
            .frame(width: size, height: size)
            .position(
                x: moveRight ? startX + CGFloat.random(in: -100...100) : startX,
                y: moveUp ? -50 : startY
            )
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                    opacity = 1
                }
                
                withAnimation(
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false)
                    .delay(delay)
                ) {
                    moveUp = true
                }
                
                withAnimation(
                    .easeInOut(duration: duration * 0.7)
                    .repeatForever(autoreverses: true)
                    .delay(delay + 1)
                ) {
                    moveRight = true
                }
            }
    }
}

struct AnimatedGradientOverlay: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            colors: [
                AppColors.primaryBlue.opacity(animateGradient ? 0.8 : 0.6),
                AppColors.secondaryBlue.opacity(animateGradient ? 0.6 : 0.8),
                AppColors.primaryBlue.opacity(animateGradient ? 0.9 : 0.7)
            ],
            startPoint: animateGradient ? .topTrailing : .topLeading,
            endPoint: animateGradient ? .bottomLeading : .bottomTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(
                .easeInOut(duration: 8)
                .repeatForever(autoreverses: true)
            ) {
                animateGradient = true
            }
        }
    }
}

struct ParticleSystem: View {
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles, id: \.id) { particle in
                Circle()
                    .fill(Color.white.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .scaleEffect(particle.scale)
            }
        }
        .onAppear {
            createParticles()
            startAnimation()
        }
    }
    
    private func createParticles() {
        particles = (0..<20).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...400),
                    y: CGFloat.random(in: 0...900)
                ),
                size: CGFloat.random(in: 2...8),
                opacity: Double.random(in: 0.1...0.3),
                scale: CGFloat.random(in: 0.5...1.5)
            )
        }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            updateParticles()
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].update()
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var scale: CGFloat
    
    private var velocity: CGPoint = CGPoint(
        x: CGFloat.random(in: -0.5...0.5),
        y: CGFloat.random(in: -0.5...0.5)
    )
    
    init(position: CGPoint, size: CGFloat, opacity: Double, scale: CGFloat) {
        self.position = position
        self.size = size
        self.opacity = opacity
        self.scale = scale
    }
    
    mutating func update() {
        position.x += velocity.x
        position.y += velocity.y
        
        if position.x < 0 {
            position.x = 400
        } else if position.x > 400 {
            position.x = 0
        }
        
        if position.y < 0 {
            position.y = 900
        } else if position.y > 900 {
            position.y = 0
        }
    }
}

public struct LoadingAnimation: View {
    @State private var isLoading = true
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
   public var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(0.6)
                    
                    ForEach(0..<8) { index in
                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 12, height: 12)
                            .offset(y: -45)
                            .rotationEffect(.degrees(Double(index) * 45 + rotationAngle))
                            .opacity(Double(8 - index) / 8.0)
                    }
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.white.opacity(0.8),
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 50, height: 50)
                        .scaleEffect(scale)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                Spacer()
                
                Text("Loading your ideas...")
                    .font(.nunito(.medium, size: 18))
                    .foregroundColor(AppColors.primaryText)
                    .opacity(opacity)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(
            .linear(duration: 2.0)
            .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.2
        }
    }
}

struct AlternativeLoader1: View {
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 20, height: 20)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.2),
                        value: animationAmount
                    )
            }
        }
        .onAppear {
            animationAmount = 2
        }
    }
}

struct AlternativeLoader2: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<5) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .scaleEffect(isAnimating ? 1.5 : 1.0)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
