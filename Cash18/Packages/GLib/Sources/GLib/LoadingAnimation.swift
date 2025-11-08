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
    static let background = Color.black
    static let primaryText = Color.yellow
    static let secondaryText = Color.white
    static let accent = Color.yellow
    
    static let cardBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let lightGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.black,
            Color(red: 0.05, green: 0.05, blue: 0.1),
            Color(red: 0.1, green: 0.05, blue: 0.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.15, green: 0.15, blue: 0.15),
            Color(red: 0.1, green: 0.1, blue: 0.1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tabBarBackground = Color(red: 0.05, green: 0.05, blue: 0.05)
    static let tabBarSelected = Color.yellow
    static let tabBarUnselected = Color.gray
}

extension Color {
    static let appBackground = AppColors.background
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccent = AppColors.accent
    static let appCardBackground = AppColors.cardBackground
}

public struct LoadingAnimation: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5
    @State private var rotationAngle: Double = 0
    
    public var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.accent.opacity(0.3), lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.accent, AppColors.accent.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                    
                    Circle()
                        .fill(AppColors.accent)
                        .frame(width: 20, height: 20)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
                
                Spacer()
                
                Text("Loading...")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.secondaryText.opacity(0.7))
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
        
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}
