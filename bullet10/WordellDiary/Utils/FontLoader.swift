import UIKit
import CoreText

class FontLoader {
    static let shared = FontLoader()
    
    private init() {
        loadFonts()
    }
    
    private func loadFonts() {
        let fontNames = [
            "Ubuntu-Regular",
            "Ubuntu-Bold", 
            "Ubuntu-Medium",
            "Ubuntu-Light",
            "Ubuntu-Italic",
            "Ubuntu-BoldItalic",
            "Ubuntu-MediumItalic",
            "Ubuntu-LightItalic"
        ]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
                print("Could not find font file: \(fontName).ttf")
                continue
            }
            
            guard let fontData = NSData(contentsOf: fontURL) else {
                print("Could not load font data for: \(fontName)")
                continue
            }
            
            guard let provider = CGDataProvider(data: fontData) else {
                print("Could not create data provider for: \(fontName)")
                continue
            }
            
            guard let font = CGFont(provider) else {
                print("Could not create font from data provider for: \(fontName)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                print("Failed to register font: \(fontName), error: \(String(describing: error))")
            } else {
                print("Successfully registered font: \(fontName)")
            }
        }
    }
}
