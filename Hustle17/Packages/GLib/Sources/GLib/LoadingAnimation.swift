import SwiftUI

struct FontTheme {
    static func poppinsRegular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    static func poppinsLight(size: CGFloat) -> Font {
        return Font.custom("Poppins-Light", size: size)
    }
    
    static func poppinsMedium(size: CGFloat) -> Font {
        return Font.custom("Poppins-Medium", size: size)
    }
    
    static func poppinsSemiBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-SemiBold", size: size)
    }
    
    static func poppinsBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-Bold", size: size)
    }
    
    static let largeTitle = poppinsBold(size: 34)
    static let title1 = poppinsBold(size: 28)
    static let title2 = poppinsSemiBold(size: 22)
    static let title3 = poppinsSemiBold(size: 20)
    static let headline = poppinsSemiBold(size: 17)
    static let body = poppinsRegular(size: 17)
    static let callout = poppinsRegular(size: 16)
    static let subheadline = poppinsRegular(size: 15)
    static let footnote = poppinsRegular(size: 13)
    static let caption1 = poppinsRegular(size: 12)
    static let caption2 = poppinsRegular(size: 11)
}

extension Font {
    static let theme = FontTheme.self
}

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 1.0)
    
    static let textPrimary = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let textSecondary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let textLight = Color.white
    
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, backgroundGray],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueGradient = LinearGradient(
        colors: [lightBlue, primaryBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryBlue, darkBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let theme = ColorTheme.self
}

struct AnimatedBackground: View {
    @State private var animationOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<8, id: \.self) { index in
                        Path { path in
                            let startX = CGFloat(index) * geometry.size.width / 8 + animationOffset
                            let endX = startX + geometry.size.width / 4
                            
                            path.move(to: CGPoint(x: startX, y: 0))
                            path.addLine(to: CGPoint(x: endX, y: geometry.size.height))
                        }
                        .stroke(
                            ColorTheme.lightBlue.opacity(0.3),
                            style: StrokeStyle(lineWidth: 1, dash: [5, 10])
                        )
                    }
                    
                    ForEach(0..<6, id: \.self) { index in
                        Path { path in
                            let y = CGFloat(index) * geometry.size.height / 6 + animationOffset / 2
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                        }
                        .stroke(
                            ColorTheme.primaryBlue.opacity(0.2),
                            style: StrokeStyle(lineWidth: 0.5, dash: [3, 8])
                        )
                    }
                    
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        ColorTheme.lightBlue.opacity(0.4),
                                        ColorTheme.primaryBlue.opacity(0.1)
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 60, height: 60)
                            .scaleEffect(pulseScale)
                            .position(
                                x: geometry.size.width * CGFloat(index) / 5 + 50,
                                y: geometry.size.height * 0.3 + CGFloat(index * 40) + animationOffset / 3
                            )
                    }
                }
            }
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 20)
                        .repeatForever(autoreverses: false)
                ) {
                    animationOffset = 200
                }
                
                withAnimation(
                    Animation.easeInOut(duration: 3)
                        .repeatForever(autoreverses: true)
                ) {
                    pulseScale = 1.2
                }
            }
        }
    }
}

struct StaticBackground: View {
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    ColorTheme.lightBlue.opacity(0.3),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .position(x: -50, y: -50)
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    ColorTheme.primaryBlue.opacity(0.2),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .position(x: geometry.size.width + 50, y: geometry.size.height + 50)
                }
            }
        }
    }
}

public struct LoadingAnimation: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    @State private var opacity: Double = 0
    
    public var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            ColorTheme.primaryBlue.opacity(0.3),
                            style: StrokeStyle(lineWidth: 4, dash: [10, 5])
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .stroke(
                            ColorTheme.darkBlue.opacity(0.6),
                            style: StrokeStyle(lineWidth: 3)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-rotationAngle * 1.5))
                    
                    Circle()
                        .fill(ColorTheme.blueGradient)
                        .frame(width: 40, height: 40)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(ColorTheme.textLight)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .opacity(isAnimating ? 1.0 : 0.7)
                }
                .opacity(opacity)
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(.theme.title3)
                        .foregroundColor(ColorTheme.textPrimary)
                        .opacity(opacity)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(ColorTheme.primaryBlue)
                                .frame(width: 8, height: 8)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                    .opacity(opacity)
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.5)) {
            opacity = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 3.0)
                .repeatForever(autoreverses: false)
        ) {
            rotationAngle = 360
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.3
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            isAnimating = true
        }
    }
}
