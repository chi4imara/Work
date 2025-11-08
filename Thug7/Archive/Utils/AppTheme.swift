import SwiftUI

struct AppTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    static let backgroundWhite = Color.white
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let cardBackground = Color(red: 0.98, green: 0.98, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.9, green: 0.95, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.98, green: 0.99, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static func customFont(_ name: String, size: CGFloat) -> Font {
        if let uiFont = FontManager.shared.getFont(name: name, size: size) {
            return Font(uiFont)
        }
        return Font.custom(name, size: size)
    }
    
    static let poppinsRegular = "Poppins-Regular"
    static let poppinsMedium = "Poppins-Medium"
    static let poppinsSemiBold = "Poppins-SemiBold"
    static let poppinsBold = "Poppins-Bold"
    static let poppinsLight = "Poppins-Light"
    
    static let titleFont = Font.custom(poppinsBold, size: 24)
    static let headlineFont = Font.custom(poppinsSemiBold, size: 18)
    static let bodyFont = Font.custom(poppinsRegular, size: 16)
    static let captionFont = Font.custom(poppinsLight, size: 14)
    static let buttonFont = Font.custom(poppinsMedium, size: 16)
    
    static let titleFontFallback = Font.title2.weight(.bold)
    static let headlineFontFallback = Font.headline.weight(.semibold)
    static let bodyFontFallback = Font.body
    static let captionFontFallback = Font.caption.weight(.light)
    static let buttonFontFallback = Font.body.weight(.medium)
    
    static let cardShadow = Color.black.opacity(0.1)
    static let buttonShadow = Color.black.opacity(0.2)
    
    static let cornerRadius: CGFloat = 12
    static let buttonCornerRadius: CGFloat = 10
    static let cardCornerRadius: CGFloat = 16
}

extension View {
    func appBackground() -> some View {
        self.background(AppTheme.backgroundGradient.ignoresSafeArea())
    }
    
    func cardStyle() -> some View {
        self
            .background(AppTheme.cardGradient)
            .cornerRadius(AppTheme.cardCornerRadius)
            .shadow(color: AppTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(AppTheme.buttonFont)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppTheme.buttonGradient)
            .cornerRadius(AppTheme.buttonCornerRadius)
            .shadow(color: AppTheme.buttonShadow, radius: 4, x: 0, y: 2)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(AppTheme.buttonFont)
            .foregroundColor(AppTheme.primaryBlue)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius)
                    .stroke(AppTheme.primaryBlue, lineWidth: 2)
            )
            .cornerRadius(AppTheme.buttonCornerRadius)
    }
}
