import SwiftUI

struct AppFonts {
    private static let ralewayLight = "Raleway-Light"
    private static let ralewayRegular = "Raleway-Regular"
    private static let ralewayMedium = "Raleway-Medium"
    private static let ralewaySemiBold = "Raleway-SemiBold"
    private static let ralewayBold = "Raleway-Bold"
    
    private static func customFont(_ name: String, size: CGFloat) -> Font {
        return FontManager.loadFont(name, size: size)
    }
    
    static let largeTitle = customFont(ralewayBold, size: 28)
    static let title = customFont(ralewaySemiBold, size: 22)
    static let title2 = customFont(ralewaySemiBold, size: 20)
    static let title3 = customFont(ralewayMedium, size: 18)
    
    static let body = customFont(ralewayRegular, size: 16)
    static let bodyMedium = customFont(ralewayMedium, size: 16)
    static let callout = customFont(ralewayRegular, size: 15)
    static let subheadline = customFont(ralewayRegular, size: 13)
    
    static let footnote = customFont(ralewayRegular, size: 12)
    static let caption = customFont(ralewayLight, size: 11)
    static let caption2 = customFont(ralewayLight, size: 10)
    
    static let buttonLarge = customFont(ralewaySemiBold, size: 18)
    static let buttonMedium = customFont(ralewayMedium, size: 16)
    static let buttonSmall = customFont(ralewayMedium, size: 14)
}
