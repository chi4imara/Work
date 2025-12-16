import SwiftUI
import CoreText

struct FontManager {
    private static var fontsRegistered = false
    
    static func registerFonts() {
        guard !fontsRegistered else { return }
        
        let fontNames = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-BoldItalic"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
                
                if !success, let cfError = error?.takeRetainedValue() {
                    let errorCode = CFErrorGetCode(cfError)
                    if errorCode == 105 {
                        continue
                    }
                }
            }
        }
        
        fontsRegistered = true
    }
    
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .bold:
            return Font.custom("PlayfairDisplay-Bold", size: size)
        case .medium:
            return Font.custom("PlayfairDisplay-Bold", size: size)
        default:
            return Font.custom("PlayfairDisplay-Regular", size: size)
        }
    }
    
    static func playfairDisplayItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .bold:
            return Font.custom("PlayfairDisplay-BoldItalic", size: size)
        default:
            return Font.custom("PlayfairDisplay-Italic", size: size)
        }
    }
}

extension Font {
    static func appTitle(_ size: CGFloat = 28) -> Font {
        return FontManager.playfairDisplay(size: size, weight: .bold)
    }
    
    static func appHeadline(_ size: CGFloat = 20) -> Font {
        return FontManager.playfairDisplay(size: size, weight: .bold)
    }
    
    static func appBody(_ size: CGFloat = 16) -> Font {
        return FontManager.playfairDisplay(size: size)
    }
    
    static func appCaption(_ size: CGFloat = 14) -> Font {
        return FontManager.playfairDisplay(size: size)
    }
}