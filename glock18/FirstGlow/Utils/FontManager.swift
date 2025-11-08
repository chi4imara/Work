import SwiftUI

struct FontManager {
    
    enum BuilderSansWeight: String {
        case thin = "BuilderSans-Thin-100"
        case light = "BuilderSans-Light-300"
        case regular = "BuilderSans-Regular-400"
        case medium = "BuilderSans-Medium-500"
        case semiBold = "BuilderSans-SemiBold-600"
        case bold = "BuilderSans-Bold-700"
        case extraBold = "BuilderSans-ExtraBold-800"
    }
    
    static func builderSans(_ weight: BuilderSansWeight, size: CGFloat) -> Font {
        if UIFont(name: weight.rawValue, size: size) != nil {
            return Font.custom(weight.rawValue, size: size)
        } else {
            let systemWeight: Font.Weight
            switch weight {
            case .thin: systemWeight = .thin
            case .light: systemWeight = .light
            case .regular: systemWeight = .regular
            case .medium: systemWeight = .medium
            case .semiBold: systemWeight = .semibold
            case .bold: systemWeight = .bold
            case .extraBold: systemWeight = .heavy
            }
            return Font.system(size: size, weight: systemWeight)
        }
    }
    
    static let largeTitle = builderSans(.bold, size: 34)
    static let title1 = builderSans(.bold, size: 28)
    static let title2 = builderSans(.semiBold, size: 22)
    static let title3 = builderSans(.semiBold, size: 20)
    static let headline = builderSans(.semiBold, size: 17)
    static let body = builderSans(.regular, size: 17)
    static let callout = builderSans(.regular, size: 16)
    static let subheadline = builderSans(.regular, size: 15)
    static let footnote = builderSans(.regular, size: 13)
    static let caption1 = builderSans(.regular, size: 12)
    static let caption2 = builderSans(.regular, size: 11)
    
    static let cardTitle = builderSans(.semiBold, size: 18)
    static let cardSubtitle = builderSans(.regular, size: 14)
    static let buttonText = builderSans(.medium, size: 16)
    static let tabBarText = builderSans(.medium, size: 10)
}

extension FontManager {
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
            registerFont(bundle: Bundle.main, fontName: fontName, fontExtension: "otf")
        }
        
        print("✅ Builder Sans fonts registered successfully")
    }
    
    private static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            print("❌ Couldn't find font file: \(fontName).\(fontExtension)")
            return
        }
        
        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            print("❌ Couldn't create data provider for: \(fontName)")
            return
        }
        
        guard let font = CGFont(fontDataProvider) else {
            print("❌ Couldn't create CGFont for: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            if let error = error?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(error)
                print("❌ Error registering font \(fontName): \(errorDescription ?? "Unknown error" as CFString)")
            } else {
                print("⚠️ Font \(fontName) might already be registered")
            }
        } else {
            print("✅ Successfully registered font: \(fontName)")
        }
    }
    
    static func checkFontAvailability() {
        let testFonts = [
            "BuilderSans-Regular-400",
            "BuilderSans-Bold-700"
        ]
        
        for fontName in testFonts {
            if UIFont(name: fontName, size: 16) != nil {
                print("✅ Font \(fontName) is available")
            } else {
                print("❌ Font \(fontName) is NOT available")
            }
        }
    }
}
