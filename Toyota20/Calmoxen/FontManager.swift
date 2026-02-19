import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-BoldItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    print("Failed to register font: \(font)")
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
    }
}
