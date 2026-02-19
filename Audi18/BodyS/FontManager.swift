import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fontFiles = [
            ("Ubuntu-Regular", "Ubuntu"),
            ("Ubuntu-Bold", "Ubuntu Bold"),
            ("Ubuntu-Italic", "Ubuntu Italic"),
            ("Ubuntu-BoldItalic", "Ubuntu Bold Italic"),
            ("Ubuntu-Light", "Ubuntu Light"),
            ("Ubuntu-LightItalic", "Ubuntu Light Italic"),
            ("Ubuntu-Medium", "Ubuntu Medium"),
            ("Ubuntu-MediumItalic", "Ubuntu Medium Italic")
        ]
        
        for (fileName, fontName) in fontFiles {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    if let error = error?.takeRetainedValue() {
                        print("Failed to register font \(fontName): \(error)")
                    }
                } else {
                    print("Successfully registered font: \(fontName)")
                }
            } else {
                print("Font file not found: \(fileName).ttf")
            }
        }
    }
}

extension Font {
    static func bellGothic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Ubuntu Bold"
        case .medium:
            fontName = "Ubuntu Medium"
        case .light:
            fontName = "Ubuntu Light"
        default:
            fontName = "Ubuntu"
        }
        
        if let font = UIFont(name: fontName, size: size) {
            return Font(font)
        }
        
        return .system(size: size, weight: weight)
    }
}
