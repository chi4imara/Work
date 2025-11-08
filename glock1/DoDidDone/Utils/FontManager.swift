import SwiftUI

struct AppFonts {
    private static let poppinsRegular = "Poppins-Regular"
    private static let poppinsLight = "Poppins-Light"
    private static let poppinsMedium = "Poppins-Medium"
    private static let poppinsSemiBold = "Poppins-SemiBold"
    private static let poppinsBold = "Poppins-Bold"
    
    static func title1() -> Font {
        return Font.custom(poppinsBold, size: 28)
    }
    
    static func title2() -> Font {
        return Font.custom(poppinsSemiBold, size: 24)
    }
    
    static func title3() -> Font {
        return Font.custom(poppinsMedium, size: 20)
    }
    
    static func headline() -> Font {
        return Font.custom(poppinsSemiBold, size: 18)
    }
    
    static func body() -> Font {
        return Font.custom(poppinsRegular, size: 16)
    }
    
    static func callout() -> Font {
        return Font.custom(poppinsMedium, size: 16)
    }
    
    static func subheadline() -> Font {
        return Font.custom(poppinsRegular, size: 14)
    }
    
    static func footnote() -> Font {
        return Font.custom(poppinsLight, size: 13)
    }
    
    static func caption() -> Font {
        return Font.custom(poppinsLight, size: 12)
    }
    
    static func caption2() -> Font {
        return Font.custom(poppinsLight, size: 11)
    }
}

class FontLoader {
    static func loadFonts() {
        let fontNames = [
            "Poppins-Regular",
            "Poppins-Light", 
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
        ]
        
        for fontName in fontNames {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
    }
}
