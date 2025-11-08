import SwiftUI
import CoreText

struct AppFonts {
    private static let ralewayLight = "Raleway-Light"
    private static let ralewayRegular = "Raleway-Regular"
    private static let ralewayMedium = "Raleway-Medium"
    private static let ralewaySemiBold = "Raleway-SemiBold"
    private static let ralewayBold = "Raleway-Bold"
    
    static func registerFonts() {
        let fonts = [ralewayLight, ralewayRegular, ralewayMedium, ralewaySemiBold, ralewayBold]
        
        for font in fonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let success = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
                if !success {
                    print("Failed to register font: \(font)")
                }
            } else {
                print("Font file not found: \(font).ttf")
            }
        }
    }
    
    static func largeTitle(size: CGFloat = 34) -> Font {
        return Font.custom(ralewayBold, size: size)
    }
    
    static func title1(size: CGFloat = 28) -> Font {
        return Font.custom(ralewaySemiBold, size: size)
    }
    
    static func title2(size: CGFloat = 22) -> Font {
        return Font.custom(ralewaySemiBold, size: size)
    }
    
    static func title3(size: CGFloat = 20) -> Font {
        return Font.custom(ralewayMedium, size: size)
    }
    
    static func headline(size: CGFloat = 17) -> Font {
        return Font.custom(ralewaySemiBold, size: size)
    }
    
    static func body(size: CGFloat = 17) -> Font {
        return Font.custom(ralewayRegular, size: size)
    }
    
    static func callout(size: CGFloat = 16) -> Font {
        return Font.custom(ralewayRegular, size: size)
    }
    
    static func subheadline(size: CGFloat = 15) -> Font {
        return Font.custom(ralewayMedium, size: size)
    }
    
    static func footnote(size: CGFloat = 13) -> Font {
        return Font.custom(ralewayRegular, size: size)
    }
    
    static func caption(size: CGFloat = 12) -> Font {
        return Font.custom(ralewayLight, size: size)
    }
    
    static func caption2(size: CGFloat = 11) -> Font {
        return Font.custom(ralewayLight, size: size)
    }
    
    static func button(size: CGFloat = 17) -> Font {
        return Font.custom(ralewayMedium, size: size)
    }
    
    static func buttonLarge(size: CGFloat = 20) -> Font {
        return Font.custom(ralewaySemiBold, size: size)
    }
}
