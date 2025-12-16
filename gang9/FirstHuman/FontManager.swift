import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium", 
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-ExtraBoldItalic",
            "PlayfairDisplay-BlackItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf", subdirectory: "Playfair_Display/static") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if success {
                    print("✅ Successfully registered font: \(font)")
                } else {
                    let errorDescription = error?.takeRetainedValue().localizedDescription ?? "Unknown error"
                    print("❌ Failed to register font: \(font), error: \(errorDescription)")
                }
            } else {
                print("❌ Font file not found: \(font).ttf in Playfair_Display/static/")
            }
        }
        
        let variableFonts = [
            "PlayfairDisplay-VariableFont_wght",
            "PlayfairDisplay-Italic-VariableFont_wght"
        ]
        
        for font in variableFonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf", subdirectory: "Playfair_Display") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if success {
                    print("✅ Successfully registered variable font: \(font)")
                } else {
                    let errorDescription = error?.takeRetainedValue().localizedDescription ?? "Unknown error"
                    print("❌ Failed to register variable font: \(font), error: \(errorDescription)")
                }
            }
        }
    }
}

extension Font {
    static func playfairDisplay(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .regular:
            fontName = "PlayfairDisplay-Regular"
        case .medium:
            fontName = "PlayfairDisplay-Medium"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBold"
        case .bold:
            fontName = "PlayfairDisplay-Bold"
        case .heavy:
            fontName = "PlayfairDisplay-ExtraBold"
        case .black:
            fontName = "PlayfairDisplay-Black"
        default:
            fontName = "PlayfairDisplay-Regular"
        }
        
        if UIFont(name: fontName, size: size) != nil {
            return .custom(fontName, size: size)
        } else {
            return .system(size: size, weight: weight, design: .serif)
        }
    }
    
    static func playfairDisplayItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .regular:
            fontName = "PlayfairDisplay-Italic"
        case .medium:
            fontName = "PlayfairDisplay-MediumItalic"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBoldItalic"
        case .bold:
            fontName = "PlayfairDisplay-BoldItalic"
        case .heavy:
            fontName = "PlayfairDisplay-ExtraBoldItalic"
        case .black:
            fontName = "PlayfairDisplay-BlackItalic"
        default:
            fontName = "PlayfairDisplay-Italic"
        }
        
        if UIFont(name: fontName, size: size) != nil {
            return .custom(fontName, size: size)
        } else {
            return .system(size: size, weight: weight, design: .serif)
        }
    }
}
