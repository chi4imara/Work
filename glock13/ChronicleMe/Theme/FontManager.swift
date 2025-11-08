import UIKit
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {
        registerFonts()
    }
    
    private func registerFonts() {
        let fontNames = [
            "Raleway-Light",
            "Raleway-Regular", 
            "Raleway-Medium",
            "Raleway-SemiBold",
            "Raleway-Bold"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                if let fontData = NSData(contentsOf: fontURL) {
                    let provider = CGDataProvider(data: fontData)
                    if let font = CGFont(provider!) {
                        CTFontManagerRegisterGraphicsFont(font, nil)
                    }
                }
            }
        }
    }
    
    static func loadFont(_ name: String, size: CGFloat) -> Font {
        if let font = UIFont(name: name, size: size) {
            return Font(font)
        } else {
            return Font.system(size: size)
        }
    }
}
