import SwiftUI
import CoreText

struct FontManager {
    static func registerFonts() {
        let fontNames = [
            "BuilderSans-Bold-700",
            "BuilderSans-ExtraBold-800", 
            "BuilderSans-Light-300",
            "BuilderSans-Medium-500",
            "BuilderSans-Regular-400",
            "BuilderSans-SemiBold-600",
            "BuilderSans-Thin-100"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "otf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
                if !success {
                    if let error = error?.takeRetainedValue() {
                        print("Failed to register font: \(fontName), error: \(error)")
                    } else {
                        print("Failed to register font: \(fontName), unknown error")
                    }
                }
            } else {
                print("Font file not found: \(fontName).otf")
            }
        }
    }
    
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 16) != nil
    }
}

extension Font {
    static func builderSans(_ weight: BuilderSansWeight, size: CGFloat) -> Font {
        if FontManager.isFontAvailable(weight.fontName) {
            return Font.custom(weight.fontName, size: size)
        } else {
            return Font.system(size: size, weight: weight.systemWeight)
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
            return "BuilderSans-Thin-100"
        case .light:
            return "BuilderSans-Light-300"
        case .regular:
            return "BuilderSans-Regular-400"
        case .medium:
            return "BuilderSans-Medium-500"
        case .semiBold:
            return "BuilderSans-SemiBold-600"
        case .bold:
            return "BuilderSans-Bold-700"
        case .extraBold:
            return "BuilderSans-ExtraBold-800"
        }
    }
    
    var systemWeight: Font.Weight {
        switch self {
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
