import SwiftUI
import CoreText

struct AppFonts {
    private static let builderSansRegular = "BuilderSans-Regular-400"
    private static let builderSansLight = "BuilderSans-Light-300"
    private static let builderSansMedium = "BuilderSans-Medium-500"
    private static let builderSansSemiBold = "BuilderSans-SemiBold-600"
    private static let builderSansBold = "BuilderSans-Bold-700"
    private static let builderSansExtraBold = "BuilderSans-ExtraBold-800"
    
    private static func customFont(_ name: String, size: CGFloat) -> Font {
        return FontHelper.getFont(name, size: size)
    }
    
    static let largeTitle = customFont(builderSansBold, size: 34)
    static let title1 = customFont(builderSansBold, size: 28)
    static let title2 = customFont(builderSansSemiBold, size: 22)
    static let title3 = customFont(builderSansSemiBold, size: 20)
    static let headline = customFont(builderSansMedium, size: 17)
    static let body = customFont(builderSansRegular, size: 17)
    static let callout = customFont(builderSansRegular, size: 16)
    static let subheadline = customFont(builderSansRegular, size: 15)
    static let footnote = customFont(builderSansRegular, size: 13)
    static let caption1 = customFont(builderSansLight, size: 12)
    static let caption2 = customFont(builderSansLight, size: 11)
    
    static let pixelTitle = customFont(builderSansExtraBold, size: 24)
    static let pixelButton = customFont(builderSansBold, size: 16)
    static let pixelCaption = customFont(builderSansMedium, size: 14)
}

struct FontRegistration {
    static func registerFonts() {
        let fontNames = [
            "BuilderSans-Regular-400",
            "BuilderSans-Light-300", 
            "BuilderSans-Medium-500",
            "BuilderSans-SemiBold-600",
            "BuilderSans-Bold-700",
            "BuilderSans-ExtraBold-800",
            "BuilderSans-Thin-100"
        ]
        
        for fontName in fontNames {
            let possiblePaths = [
                "Builder Sans/\(fontName).otf",
                "\(fontName).otf",
                "Fonts/\(fontName).otf"
            ]
            
            var fontRegistered = false
            for path in possiblePaths {
                if let fontURL = Bundle.main.url(forResource: path, withExtension: nil) {
                    var error: Unmanaged<CFError>?
                    let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
                    if success {
                        print("Successfully registered font: \(fontName) from \(path)")
                        fontRegistered = true
                        break
                    } else {
                        print("Failed to register font: \(fontName) from \(path)")
                        if let error = error?.takeRetainedValue() {
                            print("Error: \(error)")
                        }
                    }
                }
            }
            
            if !fontRegistered {
                print("Font file not found: \(fontName).otf")
            }
        }
    }
    
    static func isFontRegistered(_ fontName: String) -> Bool {
        let font = UIFont(name: fontName, size: 16)
        return font != nil
    }
    
    static func listAvailableFonts() {
        print("Available fonts:")
        for family in UIFont.familyNames.sorted() {
            print("Family: \(family)")
            for font in UIFont.fontNames(forFamilyName: family) {
                print("  - \(font)")
            }
        }
    }
}
