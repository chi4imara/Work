import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "BuilderSans-Thin-100",
            "BuilderSans-Light-300",
            "BuilderSans-Regular-400",
            "BuilderSans-Medium-500",
            "BuilderSans-SemiBold-600",
            "BuilderSans-Bold-700",
            "BuilderSans-ExtraBold-800"
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "otf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    print("Failed to register font: \(font)")
                }
            }
        }
    }
}

extension Font {
    static func builderSans(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .thin:
            return .custom("BuilderSans-Thin", size: size)
        case .light:
            return .custom("BuilderSans-Light", size: size)
        case .regular:
            return .custom("BuilderSans-Regular", size: size)
        case .medium:
            return .custom("BuilderSans-Medium", size: size)
        case .semibold:
            return .custom("BuilderSans-SemiBold", size: size)
        case .bold:
            return .custom("BuilderSans-Bold", size: size)
        case .heavy:
            return .custom("BuilderSans-ExtraBold", size: size)
        default:
            return .custom("BuilderSans-Regular", size: size)
        }
    }
}
