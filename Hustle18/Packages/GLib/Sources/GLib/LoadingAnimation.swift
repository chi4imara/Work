import SwiftUI

class FontRegistration {
    static func registerFonts() {
        let fontNames = [
            "Raleway-Light",
            "Raleway-Regular",
            "Raleway-Medium",
            "Raleway-SemiBold",
            "Raleway-Bold"
        ]
        
        for fontName in fontNames {
            registerFont(fontName: fontName)
        }
    }
    
    private static func registerFont(fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
            print("Could not find font file: \(fontName).ttf")
            return
        }
        
        guard let fontData = NSData(contentsOf: fontURL) else {
            print("Could not load font data for: \(fontName)")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("Could not create data provider for: \(fontName)")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("Could not create font from data provider for: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Failed to register font: \(fontName), error: \(String(describing: error))")
        } else {
            print("Successfully registered font: \(fontName)")
        }
    }
}

extension Font {
    static func ralewayLight(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Light", size: size)
    }
    
    static func ralewayRegular(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Regular", size: size)
    }
    
    static func ralewayMedium(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Medium", size: size)
    }
    
    static func ralewaySemiBold(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-SemiBold", size: size)
    }
    
    static func ralewayBold(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Bold", size: size)
    }
    
    static let dreamTitle = Font.ralewayBold(28)
    static let dreamHeadline = Font.ralewaySemiBold(22)
    static let dreamSubheadline = Font.ralewayMedium(18)
    static let dreamBody = Font.ralewayRegular(16)
    static let dreamCaption = Font.ralewayLight(14)
    static let dreamSmall = Font.ralewayLight(12)
}

extension Color {
    static let dreamBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let dreamYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let dreamWhite = Color.white
    static let dreamPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let dreamPink = Color(red: 1.0, green: 0.6, blue: 0.8)
    static let dreamMint = Color(red: 0.4, green: 0.9, blue: 0.7)
    
    static let primaryBackground = LinearGradient(
        colors: [dreamBlue.opacity(0.8), dreamBlue.opacity(0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let tagColors: [Color] = [
        dreamYellow,
        dreamPurple,
        dreamPink,
        dreamMint,
        Color.orange,
        Color.cyan
    ]
    
    static func tagColor(for tag: String) -> Color {
        let index = abs(tag.hashValue) % tagColors.count
        return tagColors[index]
    }
}
struct BackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.dreamBlue.opacity(0.8),
                    Color.dreamBlue.opacity(0.4),
                    Color.dreamPurple.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            WebPatternView()
                .opacity(0.3)
        }
        .ignoresSafeArea()
    }
}

struct WebPatternView: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 60
            let lineWidth: CGFloat = 1
            
            for y in stride(from: 0, through: size.height, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.dreamBlue.opacity(0.5)), lineWidth: lineWidth)
            }
            
            for x in stride(from: 0, through: size.width, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.dreamBlue.opacity(0.5)), lineWidth: lineWidth)
            }
            
            for y in stride(from: 0, through: size.height, by: spacing * 2) {
                for x in stride(from: 0, through: size.width, by: spacing * 2) {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y))
                    path.addLine(to: CGPoint(x: x + spacing, y: y + spacing))
                    context.stroke(path, with: .color(.dreamBlue.opacity(0.3)), lineWidth: lineWidth * 0.5)
                }
            }
        }
    }
}


public struct LoadingAnimation: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
   public var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.dreamYellow.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [Color.dreamYellow, Color.dreamPink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.dreamWhite.opacity(0.8), Color.dreamYellow.opacity(0.4)],
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    Circle()
                        .fill(Color.dreamYellow)
                        .frame(width: 8, height: 8)
                }
                
                Spacer()
                
                Text("Loading dreams...")
                    .font(.dreamCaption)
                    .foregroundColor(Color.blue.opacity(0.8))
                    .opacity(isAnimating ? 1 : 0.5)
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            isAnimating = true
            scale = 1.2
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}
