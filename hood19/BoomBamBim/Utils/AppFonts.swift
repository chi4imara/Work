import SwiftUI

struct AppFonts {
    private static let poppinsLight = "Poppins-Light"
    private static let poppinsRegular = "Poppins-Regular"
    private static let poppinsMedium = "Poppins-Medium"
    private static let poppinsSemiBold = "Poppins-SemiBold"
    private static let poppinsBold = "Poppins-Bold"
    
    static let largeTitle = Font.custom(poppinsBold, size: 34)
    static let title1 = Font.custom(poppinsBold, size: 28)
    static let title2 = Font.custom(poppinsSemiBold, size: 22)
    static let title3 = Font.custom(poppinsSemiBold, size: 20)
    
    static let headline = Font.custom(poppinsSemiBold, size: 17)
    static let body = Font.custom(poppinsRegular, size: 17)
    static let bodyMedium = Font.custom(poppinsMedium, size: 17)
    static let callout = Font.custom(poppinsRegular, size: 16)
    static let subheadline = Font.custom(poppinsRegular, size: 15)
    
    static let footnote = Font.custom(poppinsRegular, size: 13)
    static let caption1 = Font.custom(poppinsRegular, size: 12)
    static let caption2 = Font.custom(poppinsLight, size: 11)
    
    static let navigationTitle = Font.custom(poppinsSemiBold, size: 18)
    static let buttonText = Font.custom(poppinsMedium, size: 16)
    static let cardTitle = Font.custom(poppinsSemiBold, size: 16)
    static let cardSubtitle = Font.custom(poppinsRegular, size: 14)
    
    static func registerFonts() {
        let fontNames = [
            "Poppins-Light",
            "Poppins-Regular", 
            "Poppins-Medium",
            "Poppins-SemiBold",
            "Poppins-Bold"
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
