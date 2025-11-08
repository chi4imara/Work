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
    static let caption = poppinsLight(size: 12)
    static let small = poppinsLight(size: 10)
    
    static let largeTitle = poppinsBold(size: 32)
    static let cardTitle = poppinsSemiBold(size: 18)
    static let cardSubtitle = poppinsRegular(size: 14)
    static let buttonText = poppinsMedium(size: 16)
    static let tabBarText = poppinsMedium(size: 12)
}

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.7)
    
    static let backgroundColor = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let lightText = Color(red: 0.4, green: 0.6, blue: 0.8)
    
    static let readingColor = Color.blue
    static let completedColor = Color.green
    static let wantToReadColor = Color.orange
    
    static let accentColor = primaryBlue
    static let destructiveColor = Color.red
    static let warningColor = Color.orange
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color(red: 0.95, green: 0.98, blue: 1.0),
            Color(red: 0.9, green: 0.95, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let bubbleGradient = RadialGradient(
        gradient: Gradient(colors: [
            lightBlue.opacity(0.3),
            primaryBlue.opacity(0.1),
            Color.clear
        ]),
        center: .center,
        startRadius: 20,
        endRadius: 100
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            cardBackground,
            Color(red: 0.96, green: 0.98, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct BubbleEffect: View {
    @State private var animate = false
    let size: CGFloat
    let delay: Double
    
    var body: some View {
        Circle()
            .fill(AppColors.bubbleGradient)
            .frame(width: size, height: size)
            .scaleEffect(animate ? 1.2 : 0.8)
            .opacity(animate ? 0.3 : 0.6)
            .animation(
                Animation.easeInOut(duration: 3.0 + delay)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    animate = true
                }
            }
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    BubbleEffect(size: 80, delay: 0.0)
                    Spacer()
                    BubbleEffect(size: 60, delay: 1.0)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                HStack {
                    Spacer()
                    BubbleEffect(size: 100, delay: 2.0)
                }
                .padding(.horizontal, 50)
                
                Spacer()
                
                HStack {
                    BubbleEffect(size: 70, delay: 1.5)
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 100)
        }
    }
}
 
public struct LoadingAnimation: View {
    @State private var isLoading = true
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.3
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
   public var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(AppColors.lightBlue, lineWidth: 4)
                        .frame(width: 120, height: 120)
                        .scaleEffect(pulseScale)
                        .opacity(0.6)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: pulseScale
                        )
                    
                    Circle()
                        .trim(from: 0.0, to: 0.7)
                        .stroke(AppColors.primaryBlue, lineWidth: 6)
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(
                            Animation.linear(duration: 2.0)
                                .repeatForever(autoreverses: false),
                            value: rotationAngle
                        )
                    
                    Image(systemName: "book.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(AppColors.darkBlue)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: scale
                        )
                }
                
                Text("Loading your library...")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.lightText)
                    .opacity(opacity)
                    .animation(
                        Animation.easeInOut(duration: 1.2)
                            .repeatForever(autoreverses: true),
                        value: opacity
                    )
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoading = false
                }
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            scale = 1.2
        }
        
        withAnimation(
            Animation.easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true)
        ) {
            opacity = 1.0
        }
        
        withAnimation(
            Animation.linear(duration: 2.0)
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
    }
}
