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

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let lightBlue = Color(red: 0.7, green: 0.85, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
    
    static let background = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let webBackground = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static let primaryText = Color.black
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let lightText = lightBlue
    static let darkText = darkBlue
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let accent = Color(red: 0.3, green: 0.7, blue: 0.9)
    
    static let tabBarBackground = Color.white.opacity(0.95)
    static let tabBarSelected = primaryBlue
    static let tabBarUnselected = Color.gray
    
    static let sidebarBackground = Color.white.opacity(0.98)
    static let sidebarSelected = primaryBlue
    static let sidebarUnselected = Color.gray.opacity(0.8)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color(red: 0.95, green: 0.97, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.99, green: 0.995, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueWebGradient = LinearGradient(
        gradient: Gradient(colors: [
            lightBlue.opacity(0.1),
            primaryBlue.opacity(0.05),
            lightBlue.opacity(0.08)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct WebPatternBackground: View {
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            Canvas { context, size in
                let spacing: CGFloat = 40
                let lineWidth: CGFloat = 0.5
                
                context.stroke(
                    Path { path in
                        for y in stride(from: 0, through: size.height, by: spacing) {
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: size.width, y: y))
                        }
                        
                        for x in stride(from: 0, through: size.width, by: spacing) {
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: size.height))
                        }
                    },
                    with: .color(ColorTheme.lightBlue.opacity(0.3)),
                    lineWidth: lineWidth
                )
                
                context.stroke(
                    Path { path in
                        for y in stride(from: 0, through: size.height, by: spacing * 2) {
                            for x in stride(from: 0, through: size.width, by: spacing * 2) {
                                path.move(to: CGPoint(x: x, y: y))
                                path.addLine(to: CGPoint(x: x + spacing, y: y + spacing))
                            }
                        }
                    },
                    with: .color(ColorTheme.primaryBlue.opacity(0.2)),
                    lineWidth: lineWidth * 0.7
                )
            }
            .ignoresSafeArea()
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
            WebPatternBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(opacity)
                    
                    Circle()
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    ColorTheme.primaryBlue,
                                    ColorTheme.lightBlue,
                                    ColorTheme.darkBlue,
                                    ColorTheme.primaryBlue
                                ]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    ForEach(0..<8, id: \.self) { index in
                        Circle()
                            .fill(ColorTheme.primaryBlue)
                            .frame(width: 8, height: 8)
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double(index) * 45))
                            .opacity(isAnimating ? 1.0 : 0.3)
                            .animation(
                                Animation.easeInOut(duration: 0.8)
                                    .repeatForever()
                                    .delay(Double(index) * 0.1),
                                value: isAnimating
                            )
                    }
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(ColorTheme.darkBlue)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(FontManager.subheadline)
                        .foregroundColor(ColorTheme.darkText)
                        .opacity(opacity)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Circle()
                                .fill(ColorTheme.primaryBlue)
                                .frame(width: 6, height: 6)
                                .opacity(isAnimating ? 1.0 : 0.3)
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
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeIn(duration: 0.5)) {
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isAnimating = true
        }
    }
}
