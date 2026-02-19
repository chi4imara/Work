import CoreText
import SwiftUI
import UIKit

class FontManager {
    static let shared = FontManager()
    
    private var fontNames: [String: String] = [:]
    private var registeredFonts: [String: UIFont] = [:]
    
    private init() {}
    
    func reg() {
        let fontFiles = [
            ("Bell-Gothic_Regular", "regular"),
            ("Bell-Gothic_Bold", "bold"),
            ("Bell-Gothic_Italic", "italic"),
            ("Bell-Gothic_Bold-Italic", "boldItalic"),
            ("Bell-Gothic_Black", "black"),
            ("Bell-Gothic_Black-Italic", "blackItalic")
        ]
        
        for (fileName, key) in fontFiles {
            var fontURL: URL?
            
            let pathWithSlash = "Bell Gothic Web/" + fileName
            fontURL = Bundle.main.url(forResource: pathWithSlash, withExtension: "ttf")
            
            if fontURL == nil {
                fontURL = Bundle.main.url(forResource: fileName, withExtension: "ttf")
            }
            
            if fontURL == nil {
                if let bundlePath = Bundle.main.resourcePath {
                    let fullPath = bundlePath + "/Bell Gothic Web/" + fileName + ".ttf"
                    fontURL = URL(fileURLWithPath: fullPath)
                    if !FileManager.default.fileExists(atPath: fullPath) {
                        fontURL = nil
                    }
                }
            }
            
            if let url = fontURL {
                var error: Unmanaged<CFError>?
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                
                if let error = error {
                    let errorDescription = CFErrorCopyDescription(error.takeUnretainedValue())
                    print("✗ Font registration error for \(fileName): \(errorDescription ?? "Unknown error" as CFString)")
                } else {
                    if let fontName = getFontName(from: url) {
                        fontNames[key] = fontName
                        
                        if let uiFont = UIFont(name: fontName, size: 17) {
                            registeredFonts[key] = uiFont
                            print("✓ Registered font: \(fileName) -> \(fontName)")
                        } else {
                            print("⚠ Font registered but UIFont creation failed: \(fontName)")
                            let availableFonts = UIFont.fontNames(forFamilyName: fontName.components(separatedBy: "-").first ?? fontName)
                            print("   Available fonts in family: \(availableFonts)")
                        }
                    } else {
                        print("⚠ Could not extract font name from: \(fileName)")
                    }
                }
            } else {
                print("✗ Font file not found: \(fileName).ttf")
                if let resourcePath = Bundle.main.resourcePath {
                    print("   Resource path: \(resourcePath)")
                }
            }
        }
        
        print("📝 Registered font names: \(fontNames)")
        print("📝 Available UIFont families: \(UIFont.familyNames.filter { $0.contains("Bell") || $0.contains("bell") })")
        
        let allFamilies = UIFont.familyNames.sorted()
        print("📝 All font families (first 20): \(Array(allFamilies.prefix(20)))")
        
        for family in allFamilies {
            if family.lowercased().contains("bell") {
                let fonts = UIFont.fontNames(forFamilyName: family)
                print("📝 Found Bell family: \(family) with fonts: \(fonts)")
            }
        }
    }
    
    private func getFontName(from url: URL) -> String? {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL),
              let font = CGFont(fontDataProvider) else {
            return nil
        }
        return font.postScriptName as String?
    }
    
    func getFontName(for key: String) -> String? {
        return fontNames[key]
    }
    
    func getUIFont(for key: String, size: CGFloat) -> UIFont? {
        if let fontName = fontNames[key] {
            return UIFont(name: fontName, size: size)
        }
        return nil
    }
}

extension Font {
    static func bellGothic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontKey: String
        switch weight {
        case .bold:
            fontKey = "bold"
        case .black:
            fontKey = "black"
        default:
            fontKey = "regular"
        }
        
        if let fontName = FontManager.shared.getFontName(for: fontKey) {
            let font = Font.custom(fontName, size: size)
            if UIFont(name: fontName, size: size) != nil {
                return font
            }
        }
        
        if let uiFont = FontManager.shared.getUIFont(for: fontKey, size: size) {
            return Font(uiFont)
        }
        
        let fallbackNames: [String]
        switch weight {
        case .bold:
            fallbackNames = [
                "BellGothicStd-Bold",
                "BellGothic-Bold",
                "Bell Gothic Std Bold",
                "BellGothicStdBold"
            ]
        case .black:
            fallbackNames = [
                "BellGothicStd-Black",
                "BellGothic-Black",
                "Bell Gothic Std Black",
                "BellGothicStdBlack"
            ]
        default:
            fallbackNames = [
                "BellGothicStd",
                "BellGothic-Regular",
                "Bell Gothic Std",
                "BellGothicStdRegular"
            ]
        }
        
        for name in fallbackNames {
            if UIFont(name: name, size: size) != nil {
                return .custom(name, size: size)
            }
        }
        
        print("⚠ Using system font fallback for Bell Gothic")
        return .system(size: size, weight: weight)
    }
}
