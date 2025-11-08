import SwiftUI

struct AppFonts {
    private static let ralewayLight = "Raleway-Light"
    private static let ralewayRegular = "Raleway-Regular"
    private static let ralewayMedium = "Raleway-Medium"
    private static let ralewaySemiBold = "Raleway-SemiBold"
    private static let ralewayBold = "Raleway-Bold"
    
    private static func customFont(_ name: String, size: CGFloat, fallback: Font.Weight = .regular) -> Font {
        if UIFont(name: name, size: size) != nil {
            return Font.custom(name, size: size)
        } else {
            return Font.system(size: size, weight: fallback)
        }
    }
    
    static let largeTitle = customFont(ralewayBold, size: 34, fallback: .bold)
    static let title1 = customFont(ralewaySemiBold, size: 28, fallback: .semibold)
    static let title2 = customFont(ralewaySemiBold, size: 22, fallback: .semibold)
    static let title3 = customFont(ralewayMedium, size: 20, fallback: .medium)
    
    static let body = customFont(ralewayRegular, size: 17, fallback: .regular)
    static let bodyMedium = customFont(ralewayMedium, size: 17, fallback: .medium)
    static let callout = customFont(ralewayRegular, size: 16, fallback: .regular)
    static let subheadline = customFont(ralewayRegular, size: 15, fallback: .regular)
    
    static let footnote = customFont(ralewayRegular, size: 13, fallback: .regular)
    static let caption1 = customFont(ralewayRegular, size: 12, fallback: .regular)
    static let caption2 = customFont(ralewayLight, size: 10, fallback: .light)
    
    static let buttonLarge = customFont(ralewaySemiBold, size: 18, fallback: .semibold)
    static let buttonMedium = customFont(ralewayMedium, size: 16, fallback: .medium)
    static let buttonSmall = customFont(ralewayMedium, size: 14, fallback: .medium)
}
