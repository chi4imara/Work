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
    static let title2 = bold(22)
    static let title3 = semiBold(20)
    static let headline = semiBold(17)
    static let body = regular(17)
    static let callout = regular(16)
    static let subheadline = regular(15)
    static let footnote = regular(13)
    static let caption1 = regular(12)
    static let caption2 = regular(11)
}

class FontManager {
    static func registerFonts() {
        let fontNames = [
            "Poppins-Light",
            "Poppins-Regular", 
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
        ]
        
        for fontName in fontNames {
            registerFont(fontName: fontName)
        }
    }
    
    private static func registerFont(fontName: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
            print("Could not find font file: \(fontName).ttf")
            return
        }
        
        guard let fontData = NSData(contentsOf: fontURL) else {
            print("Could not load font data for: \(fontName)")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("Could not create data provider for: \(fontName)")
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            print("Could not create font from data provider for: \(fontName)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Error registering font \(fontName): \(error.debugDescription)")
        }
    }
}
