import SwiftUI
import CoreText

class FontManager {
    static let shared = FontManager()
    
    private init() {
        registerFonts()
    }
    
    private func registerFonts() {
        let fontNames = [
            "Ubuntu-Regular",
            "Ubuntu-Bold", 
            "Ubuntu-Medium",
            "Ubuntu-Light",
            "Ubuntu-Italic",
            "Ubuntu-BoldItalic",
            "Ubuntu-MediumItalic",
            "Ubuntu-LightItalic"
        ]
        
        for fontName in fontNames {
            if UIFont(name: fontName, size: 16) != nil {
                print("Font already available: \(fontName)")
                continue
            }
            
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
                print("Font file not found: \(fontName).ttf")
                continue
            }
            
            guard let fontData = NSData(contentsOf: fontURL) else {
                print("Could not load font data: \(fontName)")
                continue
            }
            
            guard let provider = CGDataProvider(data: fontData) else {
                print("Could not create data provider for: \(fontName)")
                continue
            }
            
            guard let font = CGFont(provider) else {
                print("Could not create font from data provider: \(fontName)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            let success = CTFontManagerRegisterGraphicsFont(font, &error)
            
            if success {
                print("Successfully registered font: \(fontName)")
            } else {
                if let error = error?.takeRetainedValue() {
                    let errorDescription = CFErrorCopyDescription(error)
                    print("Failed to register font \(fontName): \(errorDescription ?? "Unknown error" as CFString)")
                } else {
                    print("Failed to register font \(fontName): Unknown error")
                }
            }
        }
        
        printAvailableFonts()
    }
    
    private func printAvailableFonts() {
        let fontFamilyNames = UIFont.familyNames
        print("Available font families:")
        for familyName in fontFamilyNames {
            if familyName.contains("Ubuntu") {
                print("  - \(familyName)")
                let fontNames = UIFont.fontNames(forFamilyName: familyName)
                for fontName in fontNames {
                    print("    - \(fontName)")
                }
            }
        }
    }
}

extension Font {
    static func ubuntu(_ size: CGFloat, weight: UbuntuWeight = .regular) -> Font {
        let fontName = weight.fontName
        
        if UIFont(name: fontName, size: size) != nil {
            return Font.custom(fontName, size: size)
        } else {
            let alternativeNames = getAlternativeFontNames(for: weight)
            for altName in alternativeNames {
                if UIFont(name: altName, size: size) != nil {
                    return Font.custom(altName, size: size)
                }
            }
            
            switch weight {
            case .light:
                return Font.system(size: size, weight: .light, design: .default)
            case .regular:
                return Font.system(size: size, weight: .regular, design: .default)
            case .medium:
                return Font.system(size: size, weight: .medium, design: .default)
            case .bold:
                return Font.system(size: size, weight: .bold, design: .default)
            }
        }
    }
    
    private static func getAlternativeFontNames(for weight: UbuntuWeight) -> [String] {
        switch weight {
        case .light:
            return ["Ubuntu-Light", "Ubuntu Light", "UbuntuLight"]
        case .regular:
            return ["Ubuntu-Regular", "Ubuntu Regular", "UbuntuRegular", "Ubuntu"]
        case .medium:
            return ["Ubuntu-Medium", "Ubuntu Medium", "UbuntuMedium"]
        case .bold:
            return ["Ubuntu-Bold", "Ubuntu Bold", "UbuntuBold"]
        }
    }
    
    static let ubuntuTitle = Font.ubuntu(28, weight: .bold)
    static let ubuntuHeadline = Font.ubuntu(22, weight: .medium)
    static let ubuntuSubheadline = Font.ubuntu(18, weight: .medium)
    static let ubuntuBody = Font.ubuntu(16, weight: .regular)
    static let ubuntuCaption = Font.ubuntu(14, weight: .regular)
    static let ubuntuSmall = Font.ubuntu(12, weight: .regular)
}

enum UbuntuWeight {
    case light
    case regular
    case medium
    case bold
    
    var fontName: String {
        switch self {
        case .light:
            return "Ubuntu-Light"
        case .regular:
            return "Ubuntu-Regular"
        case .medium:
            return "Ubuntu-Medium"
        case .bold:
            return "Ubuntu-Bold"
        }
    }
}

extension UIFont {
    static func ubuntu(_ size: CGFloat, weight: UbuntuWeight = .regular) -> UIFont {
        let fontName = weight.fontName
        
        if let font = UIFont(name: fontName, size: size) {
            return font
        } else {
            switch weight {
            case .light:
                return UIFont.systemFont(ofSize: size, weight: .light)
            case .regular:
                return UIFont.systemFont(ofSize: size, weight: .regular)
            case .medium:
                return UIFont.systemFont(ofSize: size, weight: .medium)
            case .bold:
                return UIFont.systemFont(ofSize: size, weight: .bold)
            }
        }
    }
}
