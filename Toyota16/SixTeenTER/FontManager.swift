import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "Ubuntu-Light",
            "Ubuntu-Regular", 
            "Ubuntu-Medium",
            "Ubuntu-Italic",
            "Ubuntu-Bold"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                
                if !success {
                    print("Failed to register font: \(font)")
                    if let error = error {
                        print("Error: \(error.takeRetainedValue())")
                    }
                } else {
                    print("Successfully registered font: \(font)")
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
    }
    
    func reg() {
        registerFonts()
    }
}
