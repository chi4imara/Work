import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "ITC Bauhaus Bold",
            "ITC Bauhaus Bold Oblique",
            "ITC Bauhaus Demi",
            "ITC Bauhaus Demi Oblique",
            "ITC Bauhaus Heavy",
            "ITC Bauhaus Heavy Oblique",
            "ITC Bauhaus Light",
            "ITC Bauhaus Light Oblique",
            "ITC Bauhaus Medium",
            "ITC Bauhaus Medium Oblique"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
}

extension Font {
    static func bauhausLight(_ size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Light", size: size)
    }
    
    static func bauhausMedium(_ size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Medium", size: size)
    }
    
    static func bauhausDemi(_ size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Demi", size: size)
    }
    
    static func bauhausBold(_ size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Bold", size: size)
    }
    
    static func bauhausHeavy(_ size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Heavy", size: size)
    }
}
