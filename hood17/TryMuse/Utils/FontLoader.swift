import UIKit
import CoreText

class FontLoader {
    static func loadCustomFonts() {
        let fontNames = [
            "Nunito-Regular",
            "Nunito-Medium", 
            "Nunito-SemiBold",
            "Nunito-Bold"
        ]
        
        for fontName in fontNames {
            loadFont(name: fontName)
        }
    }
    
    private static func loadFont(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "ttf"),
              let fontData = NSData(contentsOf: url),
              let provider = CGDataProvider(data: fontData),
              let font = CGFont(provider) else {
            print("Failed to load font: \(name)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Failed to register font: \(name)")
        }
    }
}
