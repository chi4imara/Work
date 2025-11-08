import SwiftUI

struct AppFonts {
    private static let ralewayLight = "Raleway-Light"
    private static let ralewayRegular = "Raleway-Regular"
    private static let ralewayMedium = "Raleway-Medium"
    private static let ralewaySemiBold = "Raleway-SemiBold"
    private static let ralewayBold = "Raleway-Bold"
    
    static let largeTitle = Font.custom(ralewayBold, size: 34)
    static let title1 = Font.custom(ralewaySemiBold, size: 28)
    static let title2 = Font.custom(ralewaySemiBold, size: 22)
    static let title3 = Font.custom(ralewayMedium, size: 20)
    static let headline = Font.custom(ralewaySemiBold, size: 17)
    static let body = Font.custom(ralewayRegular, size: 17)
    static let callout = Font.custom(ralewayRegular, size: 16)
    static let subheadline = Font.custom(ralewayMedium, size: 15)
    static let footnote = Font.custom(ralewayRegular, size: 13)
    static let caption1 = Font.custom(ralewayRegular, size: 12)
    static let caption2 = Font.custom(ralewayLight, size: 11)
    
    static let splashTitle = Font.custom(ralewayBold, size: 42)
    static let cardTitle = Font.custom(ralewaySemiBold, size: 18)
    static let cardSubtitle = Font.custom(ralewayRegular, size: 14)
    static let buttonText = Font.custom(ralewayMedium, size: 16)
    static let navigationTitle = Font.custom(ralewaySemiBold, size: 20)
}

extension AppFonts {
    static func registerFonts() {
        let fontNames = [
            "Raleway-Light",
            "Raleway-Regular", 
            "Raleway-Medium",
            "Raleway-SemiBold",
            "Raleway-Bold"
        ]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf"),
                  let fontData = NSData(contentsOf: fontURL),
                  let provider = CGDataProvider(data: fontData),
                  let font = CGFont(provider) else {
                print("Failed to load font: \(fontName)")
                continue
            }
            
            var error: Unmanaged<CFError>?
            if !CTFontManagerRegisterGraphicsFont(font, &error) {
                print("Failed to register font: \(fontName)")
            }
        }
    }
}
