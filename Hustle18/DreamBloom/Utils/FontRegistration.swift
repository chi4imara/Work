import SwiftUI
import CoreText

class FontRegistration {
    static func registerFonts() {
        let fontNames = [
            "Raleway-Light",
            "Raleway-Regular", 
            "Raleway-Medium",
            "Raleway-SemiBold",
            "Raleway-Bold"
        ]
        
        for fontName in fontNames {
            registerFont(fontName: fontName)
        }
    }
    
    private static func registerFont(fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
            print("Could not find font file: \(fontName).ttf")
            return
        }
        
        guard let fontData = NSData(contentsOf: fontURL) else {
            print("Could not load font data for: \(fontName)")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("Could not create data provider for: \(fontName)")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("Could not create font from data provider for: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Failed to register font: \(fontName), error: \(String(describing: error))")
        } else {
            print("Successfully registered font: \(fontName)")
        }
    }
}
