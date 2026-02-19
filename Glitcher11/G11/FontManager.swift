import CoreText
import SwiftUI
import UIKit

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fontFiles = [
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
        
        var registeredCount = 0
        
        for fontFile in fontFiles {
            var fontURL: URL?
            
            if let url = Bundle.main.url(forResource: fontFile, withExtension: "ttf", subdirectory: "Playfair_Display/static") {
                fontURL = url
            }
            else if let url = Bundle.main.url(forResource: fontFile, withExtension: "ttf") {
                fontURL = url
            }
            else if let url = Bundle.main.url(forResource: fontFile, withExtension: "ttf", subdirectory: "Playfair_Display") {
                fontURL = url
            }
            else {
                if let path = Bundle.main.path(forResource: fontFile, ofType: "ttf") {
                    fontURL = URL(fileURLWithPath: path)
                }
            }
            
            if let url = fontURL {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if success {
                    registeredCount += 1
                    #if DEBUG
                    print("✓ Successfully registered font: \(fontFile)")
                    #endif
                } else {
                    #if DEBUG
                    if let error = error?.takeRetainedValue() {
                        let errorDescription = CFErrorCopyDescription(error) as String? ?? "Unknown error"
                        if !errorDescription.contains("already registered") {
                            print("✗ Failed to register font \(fontFile): \(errorDescription)")
                        }
                    }
                    #endif
                }
            } else {
                #if DEBUG
                print("✗ Font file not found in bundle: \(fontFile)")
                #endif
            }
        }
        
        #if DEBUG
        print("\n📊 Registered \(registeredCount) out of \(fontFiles.count) fonts\n")
        printAvailableFonts()
        FontHelper.printAllAvailableFonts()
        #endif
    }
    
    private func printAvailableFonts() {
        let fontFamilyNames = UIFont.familyNames.sorted()
        print("=== Available Font Families ===")
        for familyName in fontFamilyNames {
            if familyName.contains("Playfair") {
                print("Family: \(familyName)")
                let fontNames = UIFont.fontNames(forFamilyName: familyName)
                for fontName in fontNames {
                    print("  - \(fontName)")
                }
            }
        }
    }
    
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
}

extension Font {
    static func playfairDisplay(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName = FontHelper.getFontName(for: weight, italic: false)
        
        if FontHelper.isFontAvailable(fontName) {
            return .custom(fontName, size: size)
        } else {
            #if DEBUG
            print("⚠️ Font '\(fontName)' not available, using system font")
            #endif
            return .system(size: size, weight: weight, design: .serif)
        }
    }
    
    static func playfairDisplayItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName = FontHelper.getFontName(for: weight, italic: true)
        
        if FontHelper.isFontAvailable(fontName) {
            return .custom(fontName, size: size)
        } else {
            #if DEBUG
            print("⚠️ Font '\(fontName)' not available, using system italic font")
            #endif
            return .system(size: size, weight: weight, design: .serif).italic()
        }
    }
}
