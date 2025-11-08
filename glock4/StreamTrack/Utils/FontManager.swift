import SwiftUI

struct AppFonts {
    private static let nunitoRegular = "Nunito-Regular"
    private static let nunitoMedium = "Nunito-Medium"
    private static let nunitoSemiBold = "Nunito-SemiBold"
    private static let nunitoBold = "Nunito-Bold"
    
    enum Size: CGFloat {
        case caption = 12
        case body = 16
        case title3 = 18
        case title2 = 20
        case title1 = 24
        case largeTitle = 32
    }
    
    static func regular(_ size: Size) -> Font {
        return Font.custom(nunitoRegular, size: size.rawValue)
    }
    
    static func medium(_ size: Size) -> Font {
        return Font.custom(nunitoMedium, size: size.rawValue)
    }
    
    static func semiBold(_ size: Size) -> Font {
        return Font.custom(nunitoSemiBold, size: size.rawValue)
    }
    
    static func bold(_ size: Size) -> Font {
        return Font.custom(nunitoBold, size: size.rawValue)
    }
    
    static let largeTitle = bold(.largeTitle)
    static let title1 = bold(.title1)
    static let title2 = semiBold(.title2)
    static let title3 = semiBold(.title3)
    static let body = regular(.body)
    static let bodyMedium = medium(.body)
    static let caption = regular(.caption)
    static let captionMedium = medium(.caption)
}

class FontRegistrar {
    static func registerFonts() {
        let fontNames = ["Nunito-Regular", "Nunito-Medium", "Nunito-SemiBold", "Nunito-Bold"]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") else {
                print("Could not find font file: \(fontName).ttf")
                continue
            }
            
            guard let fontData = NSData(contentsOf: fontURL) else {
                print("Could not load font data for: \(fontName)")
                continue
            }
            
            guard let dataProvider = CGDataProvider(data: fontData) else {
                print("Could not create data provider for: \(fontName)")
                continue
            }
            
            guard let font = CGFont(dataProvider) else {
                print("Could not create font from data provider for: \(fontName)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                print("Failed to register font: \(fontName). Error: \(String(describing: error))")
            } else {
                print("Successfully registered font: \(fontName)")
            }
        }
    }
}
