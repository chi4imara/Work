import SwiftUI
import UIKit
import CoreText

class FontManager {
    
    enum UbuntuFont: String {
        case regular = "Ubuntu-Regular"
        case bold = "Ubuntu-Bold"
        case light = "Ubuntu-Light"
        case medium = "Ubuntu-Medium"
        case italic = "Ubuntu-Italic"
        case boldItalic = "Ubuntu-BoldItalic"
        case lightItalic = "Ubuntu-LightItalic"
        case mediumItalic = "Ubuntu-MediumItalic"
    }
    
    static func registerFonts() {
        let fontNames = [
            "Ubuntu-Regular",
            "Ubuntu-Bold",
            "Ubuntu-Light",
            "Ubuntu-Medium",
            "Ubuntu-Italic",
            "Ubuntu-BoldItalic",
            "Ubuntu-LightItalic",
            "Ubuntu-MediumItalic"
        ]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
                print("Could not find font file: \(fontName).ttf")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
                print("Failed to register font: \(fontName), error: \(String(describing: error))")
            } else {
                print("Successfully registered font: \(fontName)")
            }
        }
    }
    
    static func ubuntu(_ type: UbuntuFont, size: CGFloat) -> Font {
        return Font.custom(type.rawValue, size: size)
    }
    
    static func ubuntuUIFont(_ type: UbuntuFont, size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

