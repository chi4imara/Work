import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "ITC Bauhaus Light",
            "ITC Bauhaus Medium", 
            "ITC Bauhaus Demi",
            "ITC Bauhaus Bold",
            "ITC Bauhaus Heavy"
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
    static func bauhaus(_ size: CGFloat, weight: BauhausWeight = .medium) -> Font {
        return Font.custom(weight.fontName, size: size)
    }
}

enum BauhausWeight {
    case light, medium, demi, bold, heavy
    
    var fontName: String {
        switch self {
        case .light: return "ITC Bauhaus Light"
        case .medium: return "ITC Bauhaus Medium"
        case .demi: return "ITC Bauhaus Demi"
        case .bold: return "ITC Bauhaus Bold"
        case .heavy: return "ITC Bauhaus Heavy"
        }
    }
}
