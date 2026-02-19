import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "Ubuntu-Regular",
            "Ubuntu-Medium",
            "Ubuntu-Light",
            "Ubuntu-Bold",
            "Ubuntu-Italic",
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func regular(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Regular", size: size)
    }
    
    static func medium(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Medium", size: size)
    }
    
    static func light(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Light", size: size)
    }
    
    static func bold(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Bold", size: size)
    }
    
    static func italic(size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Italic", size: size)
    }
}
