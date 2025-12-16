import CoreText
import CoreGraphics
import SwiftUI
import UIKit

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
            var url: URL?
            
            url = Bundle.main.url(forResource: font, withExtension: "ttf", subdirectory: "Playfair_Display/static")
            
            if url == nil {
                url = Bundle.main.url(forResource: font, withExtension: "ttf", subdirectory: "Playfair_Display")
            }
            
            if url == nil {
                url = Bundle.main.url(forResource: font, withExtension: "ttf")
            }
            
            if let fontURL = url {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
                if success {
                    if let fontData = NSData(contentsOf: fontURL),
                       let provider = CGDataProvider(data: fontData),
                       let fontRef = CGFont(provider) {
                        if let postScriptName = fontRef.postScriptName {
                            print("Successfully registered font: \(font) -> \(postScriptName)")
                        } else {
                            print("Successfully registered font: \(font)")
                        }
                    } else {
                        print("Successfully registered font: \(font)")
                    }
                } else {
                    if let error = error?.takeRetainedValue() {
                        print("Failed to register font: \(font), error: \(error)")
                    } else {
                        print("Failed to register font: \(font)")
                    }
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
    }
    
    private func getPostScriptName(from url: URL) -> String? {
        guard let fontData = NSData(contentsOf: url),
              let provider = CGDataProvider(data: fontData),
              let fontRef = CGFont(provider),
              let postScriptName = fontRef.postScriptName else {
            return nil
        }
        return postScriptName as String
    }
}

extension Font {
    static func playfairDisplay(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .ultraLight, .thin, .light:
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
            return .custom(fontName, size: size)
        } else {
            return .system(size: size, weight: weight)
        }
    }
    
    static func playfairDisplayItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .ultraLight, .thin, .light:
            fontName = "PlayfairDisplay-Italic"
        case .regular:
            fontName = "PlayfairDisplay-Italic"
        case .medium:
            fontName = "PlayfairDisplay-MediumItalic"
        case .semibold:
            fontName = "PlayfairDisplay-SemiBoldItalic"
        case .bold:
            fontName = "PlayfairDisplay-BoldItalic"
        case .heavy, .black:
            fontName = "PlayfairDisplay-BlackItalic"
        default:
            fontName = "PlayfairDisplay-Italic"
        }
        
        if UIFont(name: fontName, size: size) != nil {
            return .custom(fontName, size: size)
        } else {
            return .system(size: size, weight: weight).italic()
        }
    }
}
