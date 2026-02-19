import CoreText
import SwiftUI
import UIKit

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Medium",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Black",
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-MediumItalic",
            "PlayfairDisplay-BoldItalic",
            "PlayfairDisplay-SemiBoldItalic",
            "PlayfairDisplay-BlackItalic",
            "PlayfairDisplay-ExtraBold",
            "PlayfairDisplay-ExtraBoldItalic"
        ]
        
        for font in fonts {
            var fontURL: URL?
            
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf", subdirectory: "Playfair_Display/static") {
                fontURL = url
            } else if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                fontURL = url
            }
            
            if let url = fontURL {
                var error: Unmanaged<CFError>?
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if let error = error {
                    let cfError = error.takeUnretainedValue()
                    if let errorDescription = CFErrorCopyDescription(cfError) {
                        let description = String(describing: errorDescription)
                        print("Font registration error for \(font): \(description)")
                    } else {
                        print("Font registration error for \(font)")
                    }
                } else {
                    print("Font registered successfully: \(font)")
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
        
        printAvailableFonts()
    }
    
    private func printAvailableFonts() {
        let fontFamilies = UIFont.familyNames.sorted()
        for family in fontFamilies {
            if family.contains("Playfair") {
                print("Found font family: \(family)")
                let fonts = UIFont.fontNames(forFamilyName: family)
                for font in fonts {
                    print("  - \(font)")
                }
            }
        }
    }
    
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .light, .ultraLight, .thin:
            fontName = "PlayfairDisplay-Regular"
        case .regular:
            fontName = "PlayfairDisplay-Regular"
        case .medium:
            fontName = "PlayfairDisplay-Medium"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBold"
        case .bold:
            fontName = "PlayfairDisplay-Bold"
        case .heavy, .black:
            fontName = "PlayfairDisplay-Black"
        default:
            fontName = "PlayfairDisplay-Regular"
        }
        
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        } else {
            return Font.system(size: size, weight: weight)
        }
    }
}
