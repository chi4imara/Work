import SwiftUI
import CoreText

struct AppFonts {
    private static let playfairRegular = "PlayfairDisplay-Regular"
    private static let playfairBold = "PlayfairDisplay-Bold"
    private static let playfairMedium = "PlayfairDisplay-Medium"
    private static let playfairSemiBold = "PlayfairDisplay-SemiBold"
    private static let playfairItalic = "PlayfairDisplay-Italic"
    
    static func largeTitle() -> Font {
        return safeCustomFont(name: playfairBold, size: 34, fallback: .largeTitle)
    }
    
    static func title1() -> Font {
        return safeCustomFont(name: playfairBold, size: 28, fallback: .title)
    }
    
    static func title2() -> Font {
        return safeCustomFont(name: playfairSemiBold, size: 22, fallback: .title2)
    }
    
    static func title3() -> Font {
        return safeCustomFont(name: playfairSemiBold, size: 20, fallback: .title3)
    }
    
    static func headline() -> Font {
        return safeCustomFont(name: playfairSemiBold, size: 17, fallback: .headline)
    }
    
    static func body() -> Font {
        return safeCustomFont(name: playfairRegular, size: 17, fallback: .body)
    }
    
    static func callout() -> Font {
        return safeCustomFont(name: playfairRegular, size: 16, fallback: .callout)
    }
    
    static func subheadline() -> Font {
        return safeCustomFont(name: playfairMedium, size: 15, fallback: .subheadline)
    }
    
    static func footnote() -> Font {
        return safeCustomFont(name: playfairRegular, size: 13, fallback: .footnote)
    }
    
    static func caption() -> Font {
        return safeCustomFont(name: playfairRegular, size: 12, fallback: .caption)
    }
    
    static func caption2() -> Font {
        return safeCustomFont(name: playfairRegular, size: 11, fallback: .caption2)
    }
    
    static func bodyItalic() -> Font {
        return safeCustomFont(name: playfairItalic, size: 17, fallback: .body)
    }
    
    static func captionItalic() -> Font {
        return safeCustomFont(name: playfairItalic, size: 12, fallback: .caption)
    }
    
    private static func safeCustomFont(name: String, size: CGFloat, fallback: Font) -> Font {
        let customFont = Font.custom(name, size: size)
        
        if UIFont(name: name, size: size) != nil {
            return customFont
        } else {
            print("Custom font '\(name)' not available, using system font")
            return fallback
        }
    }
}

class FontManager {
    static func registerFonts() {
        let fontFiles = [
            "PlayfairDisplay-Regular.ttf",
            "PlayfairDisplay-Bold.ttf", 
            "PlayfairDisplay-Medium.ttf",
            "PlayfairDisplay-SemiBold.ttf",
            "PlayfairDisplay-Italic.ttf",
            "PlayfairDisplay-Black.ttf",
            "PlayfairDisplay-BlackItalic.ttf",
            "PlayfairDisplay-BoldItalic.ttf",
            "PlayfairDisplay-ExtraBold.ttf",
            "PlayfairDisplay-ExtraBoldItalic.ttf",
            "PlayfairDisplay-MediumItalic.ttf",
            "PlayfairDisplay-SemiBoldItalic.ttf"
        ]
        
        for fontFile in fontFiles {
            registerFontFromBundle(fontFileName: fontFile)
        }
    }
    
    private static func registerFontFromBundle(fontFileName: String) {
        let possiblePaths = [
            "Playfair_Display/static/\(fontFileName)",
            "Playfair_Display/\(fontFileName)",
            fontFileName
        ]
        
        for path in possiblePaths {
            if let fontURL = Bundle.main.url(forResource: path.replacingOccurrences(of: ".ttf", with: ""), withExtension: "ttf") {
                registerFontFromURL(fontURL: fontURL, fontName: fontFileName)
                return
            }
        }
        
        print("Could not find font file: \(fontFileName)")
    }
    
    private static func registerFontFromURL(fontURL: URL, fontName: String) {
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("Could not create font from URL: \(fontURL)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            if let error = error {
                let errorDescription = CFErrorCopyDescription(error.takeRetainedValue())
                print("Error registering font \(fontName): \(String(describing: errorDescription))")
            }
        } else {
            print("Successfully registered font: \(fontName)")
        }
    }
}

extension Font {
    func fallback(_ systemFont: Font) -> Font {
        return self
    }
}
