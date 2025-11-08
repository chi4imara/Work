import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "Poppins-Regular",
            "Poppins-Medium",
            "Poppins-Light",
            "Poppins-Bold",
            "Poppins-SemiBold",
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
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
    
    static func poppinsLight(size: CGFloat) -> Font {
        return Font.custom("Poppins-Light", size: size)
    }
    
    static let title = poppinsBold(size: 28)
    static let headline = poppinsSemiBold(size: 20)
    static let subheadline = poppinsMedium(size: 16)
    static let body = poppinsRegular(size: 14)
    static let caption = poppinsLight(size: 8)
    static let small = poppinsLight(size: 10)
}

struct DesignSystem {
    
    struct Colors {
        static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
        static let lightBlue = Color(red: 0.7, green: 0.85, blue: 1.0)
        static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
        
        static let backgroundPrimary = Color.white
        static let backgroundSecondary = Color(red: 0.98, green: 0.99, blue: 1.0)
        static let backgroundTertiary = Color(red: 0.95, green: 0.97, blue: 1.0)
        
        static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
        static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
        static let textLight = lightBlue
        static let textDark = darkBlue
        
        static let accent = primaryBlue
        static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
        static let warning = Color(red: 1.0, green: 0.6, blue: 0.2)
        static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
        
        static let cardBackground = Color.white
        static let cardShadow = Color.black.opacity(0.1)
        static let divider = Color(red: 0.9, green: 0.9, blue: 0.9)
        
        static let tabBarBackground = Color.white.opacity(0.95)
        static let tabBarSelected = primaryBlue
        static let tabBarUnselected = Color.gray
    }
    
    struct Gradients {
        static let backgroundGradient = LinearGradient(
            colors: [
                Colors.backgroundPrimary,
                Colors.backgroundSecondary,
                Colors.backgroundTertiary
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let blueWebGradient = LinearGradient(
            colors: [
                Colors.lightBlue.opacity(0.3),
                Colors.primaryBlue.opacity(0.1),
                Colors.darkBlue.opacity(0.2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cardGradient = LinearGradient(
            colors: [
                Colors.cardBackground,
                Colors.backgroundSecondary
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let buttonGradient = LinearGradient(
            colors: [
                Colors.primaryBlue,
                Colors.darkBlue
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let round: CGFloat = 50
    }
    
    struct Shadow {
        static let light = Color.black.opacity(0.05)
        static let medium = Color.black.opacity(0.1)
        static let heavy = Color.black.opacity(0.2)
        
        static let cardShadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            color: light,
            radius: 8,
            x: 0,
            y: 2
        )
        
        static let buttonShadow: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            color: medium,
            radius: 4,
            x: 0,
            y: 2
        )
    }
    
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .background(DesignSystem.Gradients.cardGradient)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(
                color: DesignSystem.Shadow.cardShadow.color,
                radius: DesignSystem.Shadow.cardShadow.radius,
                x: DesignSystem.Shadow.cardShadow.x,
                y: DesignSystem.Shadow.cardShadow.y
            )
    }
    
    func primaryButtonStyle() -> some View {
        self
            .foregroundColor(.white)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(DesignSystem.Gradients.buttonGradient)
            .cornerRadius(DesignSystem.CornerRadius.md)
            .shadow(
                color: DesignSystem.Shadow.buttonShadow.color,
                radius: DesignSystem.Shadow.buttonShadow.radius,
                x: DesignSystem.Shadow.buttonShadow.x,
                y: DesignSystem.Shadow.buttonShadow.y
            )
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .foregroundColor(DesignSystem.Colors.primaryBlue)
            .padding(.horizontal, DesignSystem.Spacing.lg)
            .padding(.vertical, DesignSystem.Spacing.md)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .stroke(DesignSystem.Colors.primaryBlue, lineWidth: 1)
            )
    }
    
    func backgroundGradient() -> some View {
        self
            .background(
                ZStack {
                    DesignSystem.Gradients.backgroundGradient
                        .ignoresSafeArea()
                    
                    BlueWebPattern()
                        .opacity(0.3)
                        .ignoresSafeArea()
                }
            )
    }
}

struct BlueWebPattern: View {
    var body: some View {
        Canvas { context, size in
            let path = Path { path in
                let centerX = size.width / 2
                let centerY = size.height / 2
                let radius = min(size.width, size.height) / 3
                
                for i in 0..<8 {
                    let angle = Double(i) * .pi / 4
                    let endX = centerX + cos(angle) * radius
                    let endY = centerY + sin(angle) * radius
                    
                    path.move(to: CGPoint(x: centerX, y: centerY))
                    path.addLine(to: CGPoint(x: endX, y: endY))
                }
                
                for i in 1...3 {
                    let circleRadius = radius * Double(i) / 3
                    path.addEllipse(in: CGRect(
                        x: centerX - circleRadius,
                        y: centerY - circleRadius,
                        width: circleRadius * 2,
                        height: circleRadius * 2
                    ))
                }
            }
            
            context.stroke(
                path,
                with: .color(DesignSystem.Colors.lightBlue),
                lineWidth: 1
            )
        }
    }
}

public struct LoadingAnimation: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
   public var body: some View {
        ZStack {
            DesignSystem.Gradients.backgroundGradient
                .ignoresSafeArea()
            
            BlueWebPattern()
                .opacity(0.2)
                .ignoresSafeArea()
            
            VStack(spacing: DesignSystem.Spacing.xl) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            DesignSystem.Colors.lightBlue.opacity(0.3),
                            lineWidth: 4
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(2 - pulseScale)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AngularGradient(
                                colors: [
                                    DesignSystem.Colors.primaryBlue,
                                    DesignSystem.Colors.lightBlue,
                                    DesignSystem.Colors.darkBlue
                                ],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Image(systemName: "quote.bubble")
                        .font(.system(size: 32, weight: .light))
                        .foregroundColor(DesignSystem.Colors.primaryBlue)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                VStack(spacing: DesignSystem.Spacing.sm) {
                    Text("Loading")
                        .font(FontManager.poppinsMedium(size: 18))
                        .foregroundColor(DesignSystem.Colors.textDark)
                        .opacity(opacity)
                    
                    HStack(spacing: DesignSystem.Spacing.xs) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(DesignSystem.Colors.primaryBlue)
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
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.5)) {
                }
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        
        withAnimation(.easeOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
    }
}
