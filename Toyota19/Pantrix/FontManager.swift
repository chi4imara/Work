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
            "Ubuntu-MediumItalic",
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
}
