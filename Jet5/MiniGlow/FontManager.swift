import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fontNames = [
            "Ubuntu-Regular",
            "Ubuntu-Bold",
            "Ubuntu-Medium",
            "Ubuntu-Light",
            "Ubuntu-Italic",
            "Ubuntu-BoldItalic",
            "Ubuntu-MediumItalic",
            "Ubuntu-LightItalic"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
            }
        }
    }
}

extension Font {
    static let titleLarge = Font.custom("Ubuntu-Bold", size: 28)
    static let titleMedium = Font.custom("Ubuntu-Bold", size: 24)
    static let titleSmall = Font.custom("Ubuntu-Bold", size: 20)
    
    static let bodyLarge = Font.custom("Ubuntu-Regular", size: 18)
    static let bodyMedium = Font.custom("Ubuntu-Regular", size: 16)
    static let bodySmall = Font.custom("Ubuntu-Regular", size: 14)
    
    static let caption = Font.custom("Ubuntu-Light", size: 12)
    static let captionMedium = Font.custom("Ubuntu-Medium", size: 12)
    
    static let buttonLarge = Font.custom("Ubuntu-Medium", size: 18)
    static let buttonMedium = Font.custom("Ubuntu-Medium", size: 16)
    static let buttonSmall = Font.custom("Ubuntu-Medium", size: 14)
}
