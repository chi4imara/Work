import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fonts = [
            "Raleway-Regular",
            "Raleway-Medium",
            "Raleway-Light",
            "Raleway-Bold",
            "Raleway-SemiBold",
        ]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
}

struct AppFonts {
    static func ralewayRegular(size: CGFloat) -> Font {
        return Font.custom("Raleway-Regular", size: size)
    }
    
    static func ralewayMedium(size: CGFloat) -> Font {
        return Font.custom("Raleway-Medium", size: size)
    }
    
    static func ralewaySemiBold(size: CGFloat) -> Font {
        return Font.custom("Raleway-SemiBold", size: size)
    }
    
    static func ralewayBold(size: CGFloat) -> Font {
        return Font.custom("Raleway-Bold", size: size)
    }
    
    static func ralewayLight(size: CGFloat) -> Font {
        return Font.custom("Raleway-Light", size: size)
    }
}

extension Font {
    static let appTitle = AppFonts.ralewayBold(size: 24)
    static let appHeadline = AppFonts.ralewaySemiBold(size: 20)
    static let appSubheadline = AppFonts.ralewayMedium(size: 18)
    static let appBody = AppFonts.ralewayRegular(size: 16)
    static let appCaption = AppFonts.ralewayRegular(size: 14)
    static let appSmall = AppFonts.ralewayRegular(size: 12)
}
