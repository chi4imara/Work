import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "PlayfairDisplay-Black",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-ExtraBoldItalic",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-Italic-VariableFont_wght",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Regular"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func bauhausLight(_ size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Regular", size: size)
    }
    
    static func bauhausMedium(_ size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Medium", size: size)
    }
    
    static func bauhausBold(_ size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Bold", size: size)
    }
    
    static func bauhausHeavy(_ size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Black", size: size)
    }
}
