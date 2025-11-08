import SwiftUI
import CoreText

struct FontManager {
    
    enum PlayfairDisplayFont: String, CaseIterable {
        case regular = "PlayfairDisplay-Regular"
        case medium = "PlayfairDisplay-Medium"
        case semiBold = "PlayfairDisplay-SemiBold"
        case bold = "PlayfairDisplay-Bold"
        case extraBold = "PlayfairDisplay-ExtraBold"
        case black = "PlayfairDisplay-Black"
        case italic = "PlayfairDisplay-Italic"
        case mediumItalic = "PlayfairDisplay-MediumItalic"
        case semiBoldItalic = "PlayfairDisplay-SemiBoldItalic"
        case boldItalic = "PlayfairDisplay-BoldItalic"
        case extraBoldItalic = "PlayfairDisplay-ExtraBoldItalic"
        case blackItalic = "PlayfairDisplay-BlackItalic"
    }
    
    static func playfairDisplay(_ weight: PlayfairDisplayFont, size: CGFloat) -> Font {
        if isFontAvailable(weight.rawValue) {
            return Font.custom(weight.rawValue, size: size)
        } else {
            return systemFontFallback(for: weight, size: size)
        }
    }
    
    private static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 17) != nil
    }
    
    private static func systemFontFallback(for weight: PlayfairDisplayFont, size: CGFloat) -> Font {
        switch weight {
        case .black, .blackItalic:
            return Font.system(size: size, weight: .black, design: .serif)
        case .extraBold, .extraBoldItalic:
            return Font.system(size: size, weight: .heavy, design: .serif)
        case .bold, .boldItalic:
            return Font.system(size: size, weight: .bold, design: .serif)
        case .semiBold, .semiBoldItalic:
            return Font.system(size: size, weight: .semibold, design: .serif)
        case .medium, .mediumItalic:
            return Font.system(size: size, weight: .medium, design: .serif)
        case .italic:
            return Font.system(size: size, weight: .regular, design: .serif).italic()
        default:
            return Font.system(size: size, weight: .regular, design: .serif)
        }
    }
    
    static var largeTitle: Font {
        playfairDisplay(.bold, size: 34)
    }
    
    static var title1: Font {
        playfairDisplay(.semiBold, size: 28)
    }
    
    static var title2: Font {
        playfairDisplay(.semiBold, size: 22)
    }
    
    static var title3: Font {
        playfairDisplay(.medium, size: 20)
    }
    
    static var headline: Font {
        playfairDisplay(.semiBold, size: 17)
    }
    
    static var body: Font {
        playfairDisplay(.regular, size: 17)
    }
    
    static var callout: Font {
        playfairDisplay(.regular, size: 16)
    }
    
    static var subheadline: Font {
        playfairDisplay(.regular, size: 15)
    }
    
    static var footnote: Font {
        playfairDisplay(.regular, size: 13)
    }
    
    static var caption: Font {
        playfairDisplay(.regular, size: 12)
    }
    
    static var caption2: Font {
        playfairDisplay(.regular, size: 11)
    }
}

extension FontManager {
    static func registerFonts() {
        print("🔤 Starting font registration...")
        PlayfairDisplayFont.allCases.forEach { font in
            registerFont(bundle: Bundle.main, fontName: font.rawValue, fontExtension: "ttf")
        }
        printAvailableFonts()
    }
    
    private static func printAvailableFonts() {
        print("📋 Available fonts in the app:")
        for family in UIFont.familyNames.sorted() {
            if family.contains("Playfair") {
                print("  Family: \(family)")
                for fontName in UIFont.fontNames(forFamilyName: family) {
                    print("    - \(fontName)")
                }
            }
        }
    }
    
    private static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        let possiblePaths = [
            "Playfair_Display/static/\(fontName)",
            "Playfair_Display/\(fontName)",
            fontName
        ]
        
        for path in possiblePaths {
            if let fontURL = bundle.url(forResource: path, withExtension: fontExtension) {
                if registerFontFromURL(fontURL, fontName: fontName) {
                    print("✅ Successfully registered font: \(fontName)")
                    return
                }
            }
        }
        
        print("❌ Could not find font: \(fontName)")
    }
    
    private static func registerFontFromURL(_ fontURL: URL, fontName: String) -> Bool {
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            return false
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if !success {
            if let error = error?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(error)
                print("❌ Error registering \(fontName): \(String(describing: errorDescription))")
            }
        }
        
        return success
    }
}
