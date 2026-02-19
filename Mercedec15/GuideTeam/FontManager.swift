import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-ExtraBoldItalic",
            "PlayfairDisplay-BlackItalic"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    print("Failed to register font: \(font)")
                }
            } else {
                print("Font file not found: \(font)")
            }
        }
    }
}

extension Font {
    static func playfairRegular(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-Regular", size: size)
    }
    
    static func playfairMedium(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-Medium", size: size)
    }
    
    static func playfairSemiBold(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-SemiBold", size: size)
    }
    
    static func playfairBold(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-Bold", size: size)
    }
    
    static func playfairExtraBold(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-ExtraBold", size: size)
    }
    
    static func playfairBlack(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-Black", size: size)
    }
}
