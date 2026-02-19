import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "ITC Bauhaus Bold",
            "ITC Bauhaus Demi",
            "ITC Bauhaus Heavy",
            "ITC Bauhaus Light",
            "ITC Bauhaus Medium",
            "ITC Bauhaus Bold Oblique",
            "ITC Bauhaus Demi Oblique",
            "ITC Bauhaus Heavy Oblique",
            "ITC Bauhaus Light Oblique",
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
    static func bauhausRegular(size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Medium", size: size)
    }
    
    static func bauhausBold(size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Bold", size: size)
    }
    
    static func bauhausLight(size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Light", size: size)
    }
    
    static func bauhausHeavy(size: CGFloat) -> Font {
        return Font.custom("ITC Bauhaus Heavy", size: size)
    }
}
