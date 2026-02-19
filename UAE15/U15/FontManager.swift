import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-ExtraBoldItalic",
            "PlayfairDisplay-BlackItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if let error = error {
                    print("Failed to register font \(font): \(error)")
                }
            }
        }
    }
    
    static func playfairRegular(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Regular", size: size)
    }
    
    static func playfairMedium(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Medium", size: size)
    }
    
    static func playfairSemiBold(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-SemiBold", size: size)
    }
    
    static func playfairBold(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Bold", size: size)
    }
    
    static func playfairItalic(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Italic", size: size)
    }
}
