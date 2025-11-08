import SwiftUI

struct AppFonts {
    private static let ralewayLight = "Raleway-Light"
    private static let ralewayRegular = "Raleway-Regular"
    private static let ralewayMedium = "Raleway-Medium"
    private static let ralewaySemiBold = "Raleway-SemiBold"
    private static let ralewayBold = "Raleway-Bold"
    
    private static func customFont(_ name: String, size: CGFloat) -> Font {
        if FontManager.shared.isFontLoaded(name) {
            return Font.custom(name, size: size)
        }
        
        switch name {
        case ralewayLight:
            return Font.system(size: size, weight: .light)
        case ralewayRegular:
            return Font.system(size: size, weight: .regular)
        case ralewayMedium:
            return Font.system(size: size, weight: .medium)
        case ralewaySemiBold:
            return Font.system(size: size, weight: .semibold)
        case ralewayBold:
            return Font.system(size: size, weight: .bold)
        default:
            return Font.system(size: size, weight: .regular)
        }
    }
    
    static let largeTitle = customFont(ralewayBold, size: 34)
    static let title1 = customFont(ralewaySemiBold, size: 28)
    static let title2 = customFont(ralewaySemiBold, size: 22)
    static let title3 = customFont(ralewayMedium, size: 20)
    
    static let headline = customFont(ralewaySemiBold, size: 17)
    static let body = customFont(ralewayRegular, size: 17)
    static let callout = customFont(ralewayRegular, size: 16)
    static let subheadline = customFont(ralewayMedium, size: 15)
    static let footnote = customFont(ralewayRegular, size: 13)
    static let caption1 = customFont(ralewayRegular, size: 12)
    static let caption2 = customFont(ralewayLight, size: 11)
    
    static let buttonLarge = customFont(ralewaySemiBold, size: 18)
    static let buttonMedium = customFont(ralewayMedium, size: 16)
    static let buttonSmall = customFont(ralewayMedium, size: 14)
}

extension Font {
    static let theme = AppFonts.self
}
