import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {
        registerFonts()
    }
    
    func registerFonts() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-ExtraBoldItalic"
        ]
        
        for font in fonts {
            var fontURL: URL?
            
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf", subdirectory: "Playfair_Display/static") {
                fontURL = url
            }
            else if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                fontURL = url
            }
            else if let url = Bundle.main.url(forResource: font, withExtension: "ttf", subdirectory: "Playfair_Display") {
                fontURL = url
            }
            
            if let url = fontURL {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if success {
                    print("Successfully registered font: \(font)")
                } else {
                    if let error = error?.takeRetainedValue() {
                        print("Failed to register font \(font): \(error)")
                    } else {
                        print("Failed to register font: \(font) (may already be registered)")
                    }
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
        
        printAvailableFonts()
    }
    
    private func printAvailableFonts() {
        let fontFamilyNames = UIFont.familyNames.sorted()
        if fontFamilyNames.contains("Playfair Display") {
            print("✅ Playfair Display font family is available")
            let fonts = UIFont.fontNames(forFamilyName: "Playfair Display")
            print("Available Playfair Display fonts: \(fonts)")
        } else {
            print("❌ Playfair Display font family is NOT available")
            print("Available font families (first 10): \(Array(fontFamilyNames.prefix(10)))")
            print("\n⚠️ Make sure:")
            print("1. All font files are added to the Xcode project")
            print("2. Font files are included in Target Membership")
            print("3. Font files are in the correct folder structure")
        }
    }
}

extension Font {
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName = getFontName(for: weight, italic: false)
        let customFont = Font.custom(fontName, size: size)
        
        if UIFont.fontNames(forFamilyName: "Playfair Display").contains(fontName) {
            return customFont
        } else {
            return .system(size: size, weight: weight)
        }
    }
    
    static func playfairDisplayItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName = getFontName(for: weight, italic: true)
        let customFont = Font.custom(fontName, size: size)
        
        if UIFont.fontNames(forFamilyName: "Playfair Display").contains(fontName) {
            return customFont
        } else {
            return .system(size: size, weight: weight)
        }
    }
    
    private static func getFontName(for weight: Font.Weight, italic: Bool) -> String {
        let availableFonts = UIFont.fontNames(forFamilyName: "Playfair Display")
        
        let baseName: String
        switch weight {
        case .black:
            baseName = italic ? "PlayfairDisplay-BlackItalic" : "PlayfairDisplay-Black"
        case .heavy, .bold:
            baseName = italic ? "PlayfairDisplay-BoldItalic" : "PlayfairDisplay-Bold"
        case .semibold:
            baseName = italic ? "PlayfairDisplay-SemiBoldItalic" : "PlayfairDisplay-SemiBold"
        case .medium:
            baseName = italic ? "PlayfairDisplay-MediumItalic" : "PlayfairDisplay-Medium"
        default:
            baseName = italic ? "PlayfairDisplay-Italic" : "PlayfairDisplay-Regular"
        }
        
        if availableFonts.contains(baseName) {
            return baseName
        }
        
        if italic {
            switch weight {
            case .black:
                return "PlayfairDisplay-BlackItalic"
            case .heavy, .bold:
                return "PlayfairDisplay-BoldItalic"
            case .semibold:
                return "PlayfairDisplay-SemiBoldItalic"
            case .medium:
                return "PlayfairDisplay-MediumItalic"
            default:
                return "PlayfairDisplay-Italic"
            }
        } else {
            switch weight {
            case .black:
                return "PlayfairDisplay-Black"
            case .heavy, .bold:
                return "PlayfairDisplay-Bold"
            case .semibold:
                return "PlayfairDisplay-SemiBold"
            case .medium:
                return "PlayfairDisplay-Medium"
            default:
                return "PlayfairDisplay-Regular"
            }
        }
    }
}
