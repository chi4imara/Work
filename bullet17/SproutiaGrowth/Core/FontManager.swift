import SwiftUI

struct FontManager {
    
    enum PlayfairDisplayWeight {
        case regular
        case medium
        case semiBold
        case bold
        case extraBold
        case black
        
        var fileName: String {
            switch self {
            case .regular:
                return "PlayfairDisplay-Regular"
            case .medium:
                return "PlayfairDisplay-Medium"
            case .semiBold:
                return "PlayfairDisplay-SemiBold"
            case .bold:
                return "PlayfairDisplay-Bold"
            case .extraBold:
                return "PlayfairDisplay-ExtraBold"
            case .black:
                return "PlayfairDisplay-Black"
            }
        }
    }
    
    static func playfairDisplay(weight: PlayfairDisplayWeight, size: CGFloat) -> Font {
        FontInitializer.shared.loadFonts()
        
        if FontInitializer.shared.isFontAvailable(weight.fileName) {
            return Font.custom(weight.fileName, size: size)
        } else {

            switch weight {
            case .regular:
                return .system(size: size, weight: .regular, design: .serif)
            case .medium:
                return .system(size: size, weight: .medium, design: .serif)
            case .semiBold:
                return .system(size: size, weight: .semibold, design: .serif)
            case .bold:
                return .system(size: size, weight: .bold, design: .serif)
            case .extraBold:
                return .system(size: size, weight: .heavy, design: .serif)
            case .black:
                return .system(size: size, weight: .black, design: .serif)
            }
        }
    }
    
    static let largeTitle = playfairDisplay(weight: .bold, size: 34)
    static let title1 = playfairDisplay(weight: .bold, size: 28)
    static let title2 = playfairDisplay(weight: .semiBold, size: 22)
    static let title3 = playfairDisplay(weight: .semiBold, size: 20)
    static let headline = playfairDisplay(weight: .semiBold, size: 17)
    static let body = playfairDisplay(weight: .regular, size: 17)
    static let callout = playfairDisplay(weight: .regular, size: 16)
    static let subheadline = playfairDisplay(weight: .regular, size: 15)
    static let footnote = playfairDisplay(weight: .regular, size: 13)
    static let caption1 = playfairDisplay(weight: .regular, size: 12)
    static let caption2 = playfairDisplay(weight: .regular, size: 11)
}

extension Font {
    static func playfair(_ weight: FontManager.PlayfairDisplayWeight, size: CGFloat) -> Font {
        return FontManager.playfairDisplay(weight: weight, size: size)
    }
}
