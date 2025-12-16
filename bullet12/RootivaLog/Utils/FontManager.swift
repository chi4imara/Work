import SwiftUI
import CoreText

struct AppFonts {
    private static let thin = "BuilderSans-Thin-100"
    private static let light = "BuilderSans-Light-300"
    private static let regular = "BuilderSans-Regular-400"
    private static let medium = "BuilderSans-Medium-500"
    private static let semiBold = "BuilderSans-SemiBold-600"
    private static let bold = "BuilderSans-Bold-700"
    private static let extraBold = "BuilderSans-ExtraBold-800"
    
    static func largeTitle(_ weight: FontWeight = .bold) -> Font {
        return createFont(name: fontName(for: weight), size: 34, fallback: Font.largeTitle.weight(swiftUIWeight(for: weight)))
    }
    
    static func title(_ weight: FontWeight = .semiBold) -> Font {
        return createFont(name: fontName(for: weight), size: 28, fallback: Font.title.weight(swiftUIWeight(for: weight)))
    }
    
    static func title2(_ weight: FontWeight = .semiBold) -> Font {
        return createFont(name: fontName(for: weight), size: 22, fallback: Font.title2.weight(swiftUIWeight(for: weight)))
    }
    
    static func title3(_ weight: FontWeight = .medium) -> Font {
        return createFont(name: fontName(for: weight), size: 20, fallback: Font.title3.weight(swiftUIWeight(for: weight)))
    }
    
    static func headline(_ weight: FontWeight = .semiBold) -> Font {
        return createFont(name: fontName(for: weight), size: 17, fallback: Font.headline.weight(swiftUIWeight(for: weight)))
    }
    
    static func body(_ weight: FontWeight = .regular) -> Font {
        return createFont(name: fontName(for: weight), size: 17, fallback: Font.body.weight(swiftUIWeight(for: weight)))
    }
    
    static func callout(_ weight: FontWeight = .regular) -> Font {
        return createFont(name: fontName(for: weight), size: 16, fallback: Font.callout.weight(swiftUIWeight(for: weight)))
    }
    
    static func subheadline(_ weight: FontWeight = .regular) -> Font {
        return createFont(name: fontName(for: weight), size: 15, fallback: Font.subheadline.weight(swiftUIWeight(for: weight)))
    }
    
    static func footnote(_ weight: FontWeight = .regular) -> Font {
        return createFont(name: fontName(for: weight), size: 13, fallback: Font.footnote.weight(swiftUIWeight(for: weight)))
    }
    
    static func caption(_ weight: FontWeight = .regular) -> Font {
        return createFont(name: fontName(for: weight), size: 12, fallback: Font.caption.weight(swiftUIWeight(for: weight)))
    }
    
    static func caption2(_ weight: FontWeight = .regular) -> Font {
        return createFont(name: fontName(for: weight), size: 11, fallback: Font.caption2.weight(swiftUIWeight(for: weight)))
    }
    
    private static func createFont(name: String, size: CGFloat, fallback: Font) -> Font {
        if UIFont(name: name, size: size) != nil {
            return Font.custom(name, size: size)
        } else {
            print("Font not found: \(name), using fallback")
            return fallback
        }
    }
    
    private static func fontName(for weight: FontWeight) -> String {
        switch weight {
        case .thin:
            return thin
        case .light:
            return light
        case .regular:
            return regular
        case .medium:
            return medium
        case .semiBold:
            return semiBold
        case .bold:
            return bold
        case .extraBold:
            return extraBold
        }
    }
    
    private static func swiftUIWeight(for weight: FontWeight) -> Font.Weight {
        switch weight {
        case .thin:
            return .thin
        case .light:
            return .light
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semiBold:
            return .semibold
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        }
    }
}

enum FontWeight {
    case thin
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
}

class FontManager {
    static let shared = FontManager()
    
    static func registerFonts() {
        let fontNames = [
            "BuilderSans-Thin-100",
            "BuilderSans-Light-300",
            "BuilderSans-Regular-400",
            "BuilderSans-Medium-500",
            "BuilderSans-SemiBold-600",
            "BuilderSans-Bold-700",
            "BuilderSans-ExtraBold-800"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "otf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
                
                if !success {
                    print("Failed to register font: \(fontName)")
                    if let error = error?.takeRetainedValue() {
                        print("Error: \(error)")
                    }
                } else {
                    print("Successfully registered font: \(fontName)")
                }
            } else {
                print("Font file not found: \(fontName).otf")
            }
        }
        
        printAvailableFonts()
    }
    
    private static func printAvailableFonts() {
        let fontFamilyNames = UIFont.familyNames
        print("Available font families:")
        for familyName in fontFamilyNames {
            if familyName.contains("Builder") {
                print("- \(familyName)")
                let fontNames = UIFont.fontNames(forFamilyName: familyName)
                for fontName in fontNames {
                    print("  - \(fontName)")
                }
            }
        }
    }
}
