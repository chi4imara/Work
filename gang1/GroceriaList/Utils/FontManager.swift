import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "Ubuntu-Regular",
            "Ubuntu-Medium",
            "Ubuntu-Light",
            "Ubuntu-Bold",
            "Ubuntu-Italic",
            "Ubuntu-BoldItalic",
            "Ubuntu-LightItalic",
            "Ubuntu-MediumItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func ubuntu(_ size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Regular", size: size)
    }
    
    static func ubuntuMedium(_ size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Medium", size: size)
    }
    
    static func ubuntuBold(_ size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Bold", size: size)
    }
    
    static func ubuntuLight(_ size: CGFloat) -> Font {
        return Font.custom("Ubuntu-Light", size: size)
    }
}
