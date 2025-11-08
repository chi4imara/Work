import CoreText
import SwiftUI

struct AppFonts {
    private static let poppinsLight = "Poppins-Light"
    private static let poppinsRegular = "Poppins-Regular"
    private static let poppinsMedium = "Poppins-Medium"
    private static let poppinsSemiBold = "Poppins-SemiBold"
    private static let poppinsBold = "Poppins-Bold"
    
    static func light(_ size: CGFloat) -> Font {
        return Font.custom(poppinsLight, size: size)
    }
    
    static func regular(_ size: CGFloat) -> Font {
        return Font.custom(poppinsRegular, size: size)
    }
    
    static func medium(_ size: CGFloat) -> Font {
        return Font.custom(poppinsMedium, size: size)
    }
    
    static func semiBold(_ size: CGFloat) -> Font {
        return Font.custom(poppinsSemiBold, size: size)
    }
    
    static func bold(_ size: CGFloat) -> Font {
        return Font.custom(poppinsBold, size: size)
    }
    
    static let largeTitle = bold(34)
    static let title1 = bold(28)
    static let title2 = semiBold(22)
    static let title3 = semiBold(20)
    static let headline = semiBold(17)
    static let body = regular(17)
    static let callout = regular(16)
    static let subheadline = regular(15)
    static let footnote = regular(13)
    static let caption1 = regular(12)
    static let caption2 = regular(11)
    
    static let ideaTitle = bold(24)
    static let ideaCategory = medium(16)
    static let ideaDescription = regular(15)
    static let buttonTitle = semiBold(16)
    static let tabBarTitle = medium(12)
    static let navigationTitle = semiBold(18)
}

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fontNames = [
            "Poppins-Light",
            "Poppins-Regular", 
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
        ]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
                print("❌ Could not find font file: \(fontName).ttf")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
                if let error = error?.takeRetainedValue() {
                    print("❌ Failed to register font \(fontName): \(error)")
                }
            } else {
                print("✅ Successfully registered font: \(fontName)")
            }
        }
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return AppFonts.regular(size)
    }
    
    static func poppinsMedium(size: CGFloat) -> Font {
        return AppFonts.medium(size)
    }
    
    static func poppinsSemiBold(size: CGFloat) -> Font {
        return AppFonts.semiBold(size)
    }
    
    static func poppinsBold(size: CGFloat) -> Font {
        return AppFonts.bold(size)
    }
    
    static func poppinsLight(size: CGFloat) -> Font {
        return AppFonts.light(size)
    }
    
    static let title = AppFonts.title1
    static let headline = AppFonts.headline
    static let subheadline = AppFonts.subheadline
    static let body = AppFonts.body
    static let caption = AppFonts.caption1
    static let small = AppFonts.caption2
}
