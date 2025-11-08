import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.backgroundWhite,
                    Color.lightBlue.opacity(0.3),
                    Color.backgroundWhite
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.primaryBlue.opacity(0.3),
                                Color.lightBlue.opacity(0.1)
                            ]),
                            center: .center,
                            startRadius: 5,
                            endRadius: 50
                        )
                    )
                    .frame(
                        width: CGFloat.random(in: 20...80),
                        height: CGFloat.random(in: 20...80)
                    )
                    .position(
                        x: animate ? CGFloat.random(in: 0...UIScreen.main.bounds.width) : CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: animate ? CGFloat.random(in: 0...UIScreen.main.bounds.height) : CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...8))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
        .ignoresSafeArea()
    }
}
extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let textPrimary = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let textLight = Color(red: 0.4, green: 0.7, blue: 1.0)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    
    static let moodVeryBad = Color(red: 1.0, green: 0.2, blue: 0.2)
    static let moodBad = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let moodNeutral = Color(red: 0.8, green: 0.8, blue: 0.8)
    static let moodGood = Color(red: 0.5, green: 0.8, blue: 0.3)
    static let moodVeryGood = Color(red: 0.2, green: 0.8, blue: 0.2)
}

struct AppColors {
    static let primary = Color.primaryBlue
    static let secondary = Color.darkBlue
    static let accent = Color.lightBlue
    static let background = Color.backgroundWhite
    static let surface = Color.backgroundGray
    static let textPrimary = Color.textPrimary
    static let textSecondary = Color.textSecondary
    static let textAccent = Color.textLight
}

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

public struct LoadingAnimation: View {
    @State private var isLoading = true
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    public var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.primaryBlue.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryBlue, Color.lightBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(Angle(degrees: rotationAngle))
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.primaryBlue.opacity(0.8),
                                    Color.darkBlue.opacity(0.6)
                                ]),
                                center: .center,
                                startRadius: 5,
                                endRadius: 25
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Spacer()
                
                Text("Loading your mood journey...")
                    .font(FontManager.body)
                    .foregroundColor(Color.textSecondary)
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
        withAnimation(.easeInOut(duration: 1.0)) {
            scale = 1.0
            opacity = 1.0
        }
        
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.2
        }
    }

}
