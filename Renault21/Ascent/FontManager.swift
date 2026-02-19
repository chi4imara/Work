import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-Black",
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
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
    
    static func playfairBlack(size: CGFloat) -> Font {
        return Font.custom("PlayfairDisplay-Black", size: size)
    }
}
