import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private var registeredFontNames: [String: String] = [:]
    
    private init() {}
    
    func reg() {
        let fontFiles = [
            "Bell-Gothic_Regular",
            "Bell-Gothic_Bold",
            "Bell-Gothic_Black",
            "Bell-Gothic_Italic",
            "Bell-Gothic_Bold-Italic",
            "Bell-Gothic_Black-Italic"
        ]
        
        for fileName in fontFiles {
            var fontURL: URL?
            
            if let url = Bundle.main.url(forResource: fileName, withExtension: "ttf", subdirectory: "Bell Gothic Web") {
                fontURL = url
            } else if let url = Bundle.main.url(forResource: fileName, withExtension: "ttf") {
                fontURL = url
            }
            
            if let url = fontURL {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                
                if success {
                    if let fontDataProvider = CGDataProvider(url: url as CFURL),
                       let font = CGFont(fontDataProvider) {
                        if let fontName = font.postScriptName as String? {
                            registeredFontNames[fileName] = fontName
                            print("✅ Successfully registered font: \(fontName)")
                        }
                    }
                } else if let error = error {
                    let errorDescription = error.takeUnretainedValue()
                    print("❌ Error registering font \(fileName): \(errorDescription)")
                }
            } else {
                print("⚠️ Font file not found: \(fileName).ttf")
            }
        }
        
        if !registeredFontNames.isEmpty {
            print("📝 Available custom fonts:")
            for (key, value) in registeredFontNames {
                print("  \(key) -> \(value)")
            }
        }
        
        print("\n📋 All available fonts containing 'Bell':")
        for familyName in UIFont.familyNames.sorted() {
            if familyName.lowercased().contains("bell") {
                print("  Family: \(familyName)")
                for fontName in UIFont.fontNames(forFamilyName: familyName) {
                    print("    - \(fontName)")
                }
            }
        }
    }
    
    func getFontName(for fileName: String) -> String? {
        return registeredFontNames[fileName]
    }
}

extension Font {
    static func bellGothic(_ size: CGFloat, weight: FontWeight = .regular) -> Font {
        let fileName: String
        switch weight {
        case .bold:
            fileName = "Bell-Gothic_Bold"
        case .black:
            fileName = "Bell-Gothic_Black"
        case .italic:
            fileName = "Bell-Gothic_Italic"
        case .boldItalic:
            fileName = "Bell-Gothic_Bold-Italic"
        case .blackItalic:
            fileName = "Bell-Gothic_Black-Italic"
        default:
            fileName = "Bell-Gothic_Regular"
        }
        
        if let actualFontName = FontManager.shared.getFontName(for: fileName),
           let font = UIFont(name: actualFontName, size: size) {
            return Font(font)
        }
        
        let commonNames: [String]
        switch weight {
        case .bold:
            commonNames = [
                "BellGothic-Bold",
                "Bell Gothic Bold",
                "BellGothicBold",
                "BellGothic Bold",
                "Bell-Gothic-Bold"
            ]
        case .black:
            commonNames = [
                "BellGothic-Black",
                "Bell Gothic Black",
                "BellGothicBlack",
                "BellGothic Black",
                "Bell-Gothic-Black"
            ]
        case .italic:
            commonNames = [
                "BellGothic-Italic",
                "Bell Gothic Italic",
                "BellGothicItalic",
                "BellGothic Italic",
                "Bell-Gothic-Italic"
            ]
        case .boldItalic:
            commonNames = [
                "BellGothic-BoldItalic",
                "Bell Gothic Bold Italic",
                "BellGothicBoldItalic",
                "BellGothic Bold Italic",
                "Bell-Gothic-BoldItalic"
            ]
        case .blackItalic:
            commonNames = [
                "BellGothic-BlackItalic",
                "Bell Gothic Black Italic",
                "BellGothicBlackItalic",
                "BellGothic Black Italic",
                "Bell-Gothic-BlackItalic"
            ]
        default:
            commonNames = [
                "BellGothic-Regular",
                "Bell Gothic",
                "BellGothic",
                "BellGothic Regular",
                "Bell-Gothic-Regular",
                "Bell-Gothic"
            ]
        }
        
        for fontName in commonNames {
            if let font = UIFont(name: fontName, size: size) {
                return Font(font)
            }
        }
        
        for familyName in UIFont.familyNames {
            if familyName.lowercased().contains("bell") {
                for fontName in UIFont.fontNames(forFamilyName: familyName) {
                    let fontNameLower = fontName.lowercased()
                    let matchesWeight: Bool
                    switch weight {
                    case .bold:
                        matchesWeight = fontNameLower.contains("bold") && !fontNameLower.contains("black")
                    case .black:
                        matchesWeight = fontNameLower.contains("black")
                    case .italic:
                        matchesWeight = fontNameLower.contains("italic") && !fontNameLower.contains("bold") && !fontNameLower.contains("black")
                    case .boldItalic:
                        matchesWeight = fontNameLower.contains("bold") && fontNameLower.contains("italic")
                    case .blackItalic:
                        matchesWeight = fontNameLower.contains("black") && fontNameLower.contains("italic")
                    default:
                        matchesWeight = !fontNameLower.contains("bold") && !fontNameLower.contains("black") && !fontNameLower.contains("italic")
                    }
                    
                    if matchesWeight, let font = UIFont(name: fontName, size: size) {
                        return Font(font)
                    }
                }
            }
        }
        
        let systemWeight: Font.Weight
        switch weight {
        case .bold, .boldItalic:
            systemWeight = .bold
        case .black, .blackItalic:
            systemWeight = .black
        default:
            systemWeight = .regular
        }
        return .system(size: size, weight: systemWeight)
    }
    
    enum FontWeight {
        case regular, bold, black, italic, boldItalic, blackItalic
    }
}
