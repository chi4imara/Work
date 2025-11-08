import UIKit
import CoreText

class FontRegistration {
    static func registerCustomFonts() {
        let fontNames = [
            "Poppins-Light",
            "Poppins-Regular", 
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
        ]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
                print("Could not find font file: \(fontName).ttf")
                continue
            }
            
            guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
                print("Could not create data provider for font: \(fontName)")
                continue
            }
            
            guard let font = CGFont(fontDataProvider) else {
                print("Could not create font from data provider: \(fontName)")
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
