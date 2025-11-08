import SwiftUI
import UIKit

struct FontManager {
    
    enum NunitoFont: String, CaseIterable {
        case regular = "Nunito-Regular"
        case medium = "Nunito-Medium"
        case semiBold = "Nunito-SemiBold"
        case bold = "Nunito-Bold"
    }
    
    enum FontSize: CGFloat {
        case caption = 12
        case body = 16
        case title3 = 18
        case title2 = 20
        case title1 = 24
        case largeTitle = 28
        case extraLarge = 32
    }
    
    static func nunito(_ weight: NunitoFont, size: FontSize) -> Font {
        return Font.custom(weight.rawValue, size: size.rawValue)
    }
    
    static func nunito(_ weight: NunitoFont, size: CGFloat) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
    
    static let largeTitle = nunito(.bold, size: .largeTitle)
    static let title1 = nunito(.bold, size: .title1)
    static let title2 = nunito(.semiBold, size: .title2)
    static let title3 = nunito(.semiBold, size: .title3)
    static let headline = nunito(.semiBold, size: .body)
    static let body = nunito(.regular, size: .body)
    static let callout = nunito(.medium, size: .body)
    static let subheadline = nunito(.medium, size: 14)
    static let footnote = nunito(.regular, size: 13)
    static let caption = nunito(.regular, size: .caption)
    
    static func registerFonts() {
        for font in NunitoFont.allCases {
            if let url = Bundle.main.url(forResource: font.rawValue, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
}

extension Font {
    static func nunito(_ weight: FontManager.NunitoFont, size: FontManager.FontSize) -> Font {
        return FontManager.nunito(weight, size: size)
    }
    
    static func nunito(_ weight: FontManager.NunitoFont, size: CGFloat) -> Font {
        return FontManager.nunito(weight, size: size)
    }
}
