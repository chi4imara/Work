import SwiftUI
import CoreText

class FontLoader {
    static let shared = FontLoader()
    
    private init() {
        loadFonts()
    }
    
    private func loadFonts() {
        let fontNames = [
            "Poppins-Light",
            "Poppins-Regular", 
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
        ]
        
        for fontName in fontNames {
            loadFont(name: fontName)
        }
    }
    
    private func loadFont(name: String) {
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
