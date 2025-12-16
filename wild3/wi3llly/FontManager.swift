import CoreText
import SwiftUI
import UIKit

class FontManager {
    static let shared = FontManager()
    
    private var registeredFontNames: [String: String] = [:]
    
    private init() {
        registerFonts()
    }
    
    func registerFonts() {
        let fontFiles = [
            ("BuilderSans-Bold-700", "BuilderSans-Bold"),
            ("BuilderSans-ExtraBold-800", "BuilderSans-ExtraBold"),
            ("BuilderSans-Light-300", "BuilderSans-Light"),
            ("BuilderSans-Medium-500", "BuilderSans-Medium"),
            ("BuilderSans-Regular-400", "BuilderSans-Regular"),
            ("BuilderSans-SemiBold-600", "BuilderSans-SemiBold"),
            ("BuilderSans-Thin-100", "BuilderSans-Thin")
        ]
        
        for (fileName, expectedName) in fontFiles {
            var fontURL: URL?
            
            if let url = Bundle.main.url(forResource: fileName, withExtension: "otf") {
                fontURL = url
            }
            else if let url = Bundle.main.url(forResource: fileName, withExtension: "otf", subdirectory: "Builder Sans") {
                fontURL = url
            }
            else if let url = Bundle.main.url(forResource: fileName, withExtension: "otf", subdirectory: nil) {
                fontURL = url
            }
            
            if let url = fontURL {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                
                if success {
                    if let fontDataProvider = CGDataProvider(url: url as CFURL),
                       let font = CGFont(fontDataProvider) {
                        if let postScriptName = font.postScriptName as String? {
                            registeredFontNames[expectedName] = postScriptName
                            print("✓ Registered font: \(expectedName) -> \(postScriptName)")
                        } else {
                            registeredFontNames[expectedName] = expectedName
                        }
                    }
                } else {
                    let fontDescriptor = UIFontDescriptor(fontAttributes: [.name: expectedName])
                    if let fontName = fontDescriptor.fontAttributes[.name] as? String {
                        registeredFontNames[expectedName] = fontName
                        print("✓ Found system font: \(expectedName) -> \(fontName)")
                    }
                    
                    if let error = error?.takeRetainedValue() {
                        let errorCode = CFErrorGetCode(error)
                        if errorCode != -11819 {
                            print("⚠ Warning registering font \(fileName): \(error.localizedDescription)")
                        } else {
                            print("✓ Font \(fileName) already registered")
                            registeredFontNames[expectedName] = expectedName
                        }
                    }
                }
            } else {
                print("⚠ Font file not found: \(fileName).otf")
            }
        }
        
        verifyFonts()
    }
    
    private func verifyFonts() {
        print("\n=== Font Verification ===")
        for weight in [BuilderSansWeight.regular, .bold, .medium, .semiBold, .light] {
            let fontName = getFontName(for: weight)
            let font = UIFont(name: fontName, size: 16)
            if font != nil {
                print("✓ \(weight.fontName) is available")
            } else {
                print("✗ \(weight.fontName) is NOT available (tried: \(fontName))")
                let alternatives = [
                    weight.fontName,
                    weight.fontName.replacingOccurrences(of: "BuilderSans-", with: ""),
                    weight.fontName + "-Regular",
                    weight.fontName + "-Bold",
                ]
                for alt in alternatives {
                    if UIFont(name: alt, size: 16) != nil {
                        print("  → Found alternative: \(alt)")
                        registeredFontNames[weight.fontName] = alt
                        break
                    }
                }
            }
        }
        print("=========================\n")
    }
    
    func getFontName(for weight: BuilderSansWeight) -> String {
        let expectedName = weight.fontName
        return registeredFontNames[expectedName] ?? expectedName
    }
}

extension Font {
    static func builderSans(_ weight: BuilderSansWeight, size: CGFloat) -> Font {
        let fontName = FontManager.shared.getFontName(for: weight)
        
        let customFont = Font.custom(fontName, size: size)
        
        if UIFont(name: fontName, size: size) != nil {
            return customFont
        } else {
            let systemWeight: Font.Weight
            switch weight {
            case .thin:
                systemWeight = .thin
            case .light:
                systemWeight = .light
            case .regular:
                systemWeight = .regular
            case .medium:
                systemWeight = .medium
            case .semiBold:
                systemWeight = .semibold
            case .bold:
                systemWeight = .bold
            case .extraBold:
                systemWeight = .heavy
            }
            return Font.system(size: size, weight: systemWeight)
        }
    }
}

enum BuilderSansWeight {
    case thin
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    
    var fontName: String {
        switch self {
        case .thin:
            return "BuilderSans-Thin"
        case .light:
            return "BuilderSans-Light"
        case .regular:
            return "BuilderSans-Regular"
        case .medium:
            return "BuilderSans-Medium"
        case .semiBold:
            return "BuilderSans-SemiBold"
        case .bold:
            return "BuilderSans-Bold"
        case .extraBold:
            return "BuilderSans-ExtraBold"
        }
    }
}
