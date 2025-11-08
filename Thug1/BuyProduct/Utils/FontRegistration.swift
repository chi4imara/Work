import SwiftUI
import CoreText

class FontRegistration {
    static func registerFonts() {
        let fontNames = [
            "Nunito-Regular",
            "Nunito-Medium", 
            "Nunito-SemiBold",
            "Nunito-Bold"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
    }
}
