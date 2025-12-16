import Foundation
import SwiftUI
import CoreText

struct FontManager {
    
    static func registerFonts() {
        let fontNames = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-ExtraBoldItalic"
        ]
        
        for fontName in fontNames {
            registerFont(bundle: Bundle.main, fontName: fontName, fontExtension: "ttf")
        }
    }
    
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Error registering font: maybe it was already registered.")
        }
    }
    
    static func playfairDisplay(size: CGFloat, weight: FontWeight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .regular:
            fontName = "PlayfairDisplay-Regular"
        case .medium:
            fontName = "PlayfairDisplay-Medium"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBold"
        case .bold:
            fontName = "PlayfairDisplay-Bold"
        case .black:
            fontName = "PlayfairDisplay-Black"
        case .extraBold:
            fontName = "PlayfairDisplay-ExtraBold"
        }
        return Font.custom(fontName, size: size)
    }
    
    static func playfairDisplayItalic(size: CGFloat, weight: FontWeight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .regular:
            fontName = "PlayfairDisplay-Italic"
        case .medium:
            fontName = "PlayfairDisplay-MediumItalic"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBoldItalic"
        case .bold:
            fontName = "PlayfairDisplay-BoldItalic"
        case .black:
            fontName = "PlayfairDisplay-BlackItalic"
        case .extraBold:
            fontName = "PlayfairDisplay-ExtraBoldItalic"
        }
        return Font.custom(fontName, size: size)
    }
}

enum FontWeight {
    case regular
    case medium
    case semibold
    case bold
    case black
    case extraBold
}
