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

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let secondaryBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let accentPurple = Color(red: 0.7, green: 0.5, blue: 1.0)
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    
    static let backgroundGradientStart = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let backgroundGradientEnd = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static let cardBackground = Color.white.opacity(0.9)
    static let cardShadow = Color.black.opacity(0.1)
    
    static let primaryText = Color(red: 0.2, green: 0.2, blue: 0.3)
    static let secondaryText = Color(red: 0.5, green: 0.5, blue: 0.6)
    static let lightText = Color.white
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let tabBarBackground = Color.white.opacity(0.95)
    static let tabBarSelected = primaryBlue
    static let tabBarUnselected = Color.gray
}

extension Color {
    static let appPrimary = AppColors.primaryBlue
    static let appSecondary = AppColors.secondaryBlue
    static let appAccent = AppColors.accentPurple
    static let appBackground = AppColors.backgroundGradientStart
    static let appText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
}

public struct LoadingAnimation: View {
    @State private var isAnimating = false
    @State private var scale = 0.7
    @State private var opacity = 0.5
    @State private var rotationAngle = 0.0
    
    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.backgroundGradientStart,
                    AppColors.backgroundGradientEnd,
                    AppColors.secondaryBlue.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<6) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.primaryBlue.opacity(0.1),
                                AppColors.accentPurple.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: CGFloat.random(in: 50...120))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .opacity(isAnimating ? 0.3 : 0.1)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.primaryBlue.opacity(0.3),
                                    AppColors.accentPurple.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 8
                        )
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.primaryBlue,
                                    AppColors.accentPurple
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 1.5)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    AppColors.primaryBlue.opacity(0.6),
                                    AppColors.accentPurple.opacity(0.6)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.primaryText.opacity(0.8))
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true),
                            value: opacity
                        )
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(AppColors.primaryBlue)
                                .frame(width: 6, height: 6)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
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
        }
    }
    
    private func startAnimations() {
        withAnimation {
            isAnimating = true
            rotationAngle = 360
        }
        
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            scale = 1.1
            opacity = 0.8
        }
    }
}
