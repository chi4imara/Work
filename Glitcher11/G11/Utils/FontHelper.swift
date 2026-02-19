import SwiftUI
import UIKit

struct FontHelper {
    static let fontNames: [String: String] = [
        "regular": "PlayfairDisplay-Regular",
        "medium": "PlayfairDisplay-Medium",
        "semibold": "PlayfairDisplay-SemiBold",
        "bold": "PlayfairDisplay-Bold",
        "extrabold": "PlayfairDisplay-ExtraBold",
        "black": "PlayfairDisplay-Black",
        "italic": "PlayfairDisplay-Italic",
        "mediumItalic": "PlayfairDisplay-MediumItalic",
        "semiboldItalic": "PlayfairDisplay-SemiBoldItalic",
        "boldItalic": "PlayfairDisplay-BoldItalic",
        "extraboldItalic": "PlayfairDisplay-ExtraBoldItalic",
        "blackItalic": "PlayfairDisplay-BlackItalic"
    ]
    
    static func getFontName(for weight: Font.Weight, italic: Bool = false) -> String {
        let baseName: String
        switch weight {
        case .ultraLight, .thin, .light, .regular:
            baseName = italic ? "italic" : "regular"
        case .medium:
            baseName = italic ? "mediumItalic" : "medium"
        case .semibold:
            baseName = italic ? "semiboldItalic" : "semibold"
        case .bold:
            baseName = italic ? "boldItalic" : "bold"
        case .heavy, .black:
            baseName = italic ? "blackItalic" : "black"
        default:
            baseName = italic ? "italic" : "regular"
        }
        
        return fontNames[baseName] ?? fontNames["regular"]!
    }
    
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
    
    static func printAllAvailableFonts() {
        print("\n=== ALL AVAILABLE FONTS ===")
        let families = UIFont.familyNames.sorted()
        for family in families {
            if family.lowercased().contains("playfair") {
                print("\nFamily: \(family)")
                let fonts = UIFont.fontNames(forFamilyName: family)
                for font in fonts {
                    print("  - \(font)")
                }
            }
        }
        print("==========================\n")
    }
}
