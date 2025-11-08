import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func registerFonts() {
        let fonts = [
            "Poppins-Regular",
            "Poppins-Medium",
            "Poppins-Light",
            "Poppins-Bold",
            "Poppins-SemiBold",
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    static func poppinsMedium(size: CGFloat) -> Font {
        return Font.custom("Poppins-Medium", size: size)
    }
    
    static func poppinsSemiBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-SemiBold", size: size)
    }
    
    static func poppinsBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-Bold", size: size)
    }
    
    static func poppinsLight(size: CGFloat) -> Font {
        return Font.custom("Poppins-Light", size: size)
    }
    
    static let largeTitle = poppinsBold(size: 28)
    static let title = poppinsSemiBold(size: 22)
    static let title2 = poppinsSemiBold(size: 20)
    static let title3 = poppinsMedium(size: 18)
    static let headline = poppinsMedium(size: 16)
    static let body = poppinsRegular(size: 16)
    static let callout = poppinsRegular(size: 15)
    static let subheadline = poppinsRegular(size: 14)
    static let footnote = poppinsRegular(size: 13)
    static let caption = poppinsLight(size: 12)
    static let caption2 = poppinsLight(size: 11)
}
