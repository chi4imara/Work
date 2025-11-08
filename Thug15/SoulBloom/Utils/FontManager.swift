import SwiftUI

struct FontManager {
    static let ralewayLight = "Raleway-Light"
    static let ralewayRegular = "Raleway-Regular"
    static let ralewayMedium = "Raleway-Medium"
    static let ralewaySemiBold = "Raleway-SemiBold"
    static let ralewayBold = "Raleway-Bold"
    
    static let largeTitle = Font.custom(ralewayBold, size: 28)
    static let title = Font.custom(ralewaySemiBold, size: 22)
    static let title2 = Font.custom(ralewaySemiBold, size: 20)
    static let title3 = Font.custom(ralewayMedium, size: 18)
    static let headline = Font.custom(ralewayMedium, size: 17)
    static let body = Font.custom(ralewayRegular, size: 16)
    static let callout = Font.custom(ralewayRegular, size: 15)
    static let subheadline = Font.custom(ralewayRegular, size: 14)
    static let footnote = Font.custom(ralewayRegular, size: 13)
    static let caption = Font.custom(ralewayLight, size: 12)
    static let caption2 = Font.custom(ralewayLight, size: 11)
}

extension Font {
    static func raleway(_ weight: FontWeight, size: CGFloat) -> Font {
        let fontName: String
        switch weight {
        case .light:
            fontName = FontManager.ralewayLight
        case .regular:
            fontName = FontManager.ralewayRegular
        case .medium:
            fontName = FontManager.ralewayMedium
        case .semibold:
            fontName = FontManager.ralewaySemiBold
        case .bold:
            fontName = FontManager.ralewayBold
        default:
            fontName = FontManager.ralewayRegular
        }
        return Font.custom(fontName, size: size)
    }
}

enum FontWeight {
    case light, regular, medium, semibold, bold
}
