import CoreText
import SwiftUI
import UIKit

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "Bell-Gothic_Regular",
            "Bell-Gothic_Bold",
            "Bell-Gothic_Black",
            "Bell-Gothic_Italic",
            "Bell-Gothic_Bold-Italic",
            "Bell-Gothic_Black-Italic"
        ]
        
        for font in fonts {
            var fontURL: URL?
            
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                fontURL = url
            } else if let url = Bundle.main.url(forResource: font, withExtension: "ttf", subdirectory: "Bell Gothic Web") {
                fontURL = url
            } else {
                if let notesPath = Bundle.main.path(forResource: font, ofType: "ttf", inDirectory: "Notes/Bell Gothic Web") {
                    fontURL = URL(fileURLWithPath: notesPath)
                }
            }
            
            if let url = fontURL {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    if let error = error?.takeRetainedValue() {
                        print("Failed to register font \(font): \(error)")
                    }
                } else {
                    print("Successfully registered font: \(font)")
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
    }
}

extension Font {
    static func bellGothic(_ size: CGFloat, weight: BellGothicWeight = .regular) -> Font {
        let fontName = weight.fontName
        
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        } else {
            let systemWeight: Font.Weight = {
                switch weight {
                case .regular, .italic:
                    return .regular
                case .bold, .boldItalic:
                    return .bold
                case .black, .blackItalic:
                    return .black
                }
            }()
            return .system(size: size, weight: systemWeight)
        }
    }
}

enum BellGothicWeight {
    case regular
    case bold
    case black
    case italic
    case boldItalic
    case blackItalic
    
    var fontName: String {
        switch self {
        case .regular:
            return "Bell-Gothic_Regular"
        case .bold:
            return "Bell-Gothic_Bold"
        case .black:
            return "Bell-Gothic_Black"
        case .italic:
            return "Bell-Gothic_Italic"
        case .boldItalic:
            return "Bell-Gothic_Bold-Italic"
        case .blackItalic:
            return "Bell-Gothic_Black-Italic"
        }
    }
}
