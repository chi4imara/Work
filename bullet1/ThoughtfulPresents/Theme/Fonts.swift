import SwiftUI

struct AppFonts {
    private static let ubuntuRegular = "Ubuntu-Regular"
    private static let ubuntuBold = "Ubuntu-Bold"
    private static let ubuntuMedium = "Ubuntu-Medium"
    private static let ubuntuLight = "Ubuntu-Light"
    
    static let largeTitle = Font.custom(ubuntuBold, size: 34)
    static let title1 = Font.custom(ubuntuBold, size: 28)
    static let title2 = Font.custom(ubuntuBold, size: 22)
    static let title3 = Font.custom(ubuntuMedium, size: 20)
    
    static let headline = Font.custom(ubuntuMedium, size: 17)
    static let body = Font.custom(ubuntuRegular, size: 17)
    static let callout = Font.custom(ubuntuRegular, size: 16)
    static let subheadline = Font.custom(ubuntuRegular, size: 15)
    static let footnote = Font.custom(ubuntuRegular, size: 13)
    static let caption = Font.custom(ubuntuLight, size: 12)
    static let caption2 = Font.custom(ubuntuLight, size: 11)
    
    static let buttonLarge = Font.custom(ubuntuMedium, size: 18)
    static let buttonMedium = Font.custom(ubuntuMedium, size: 16)
    static let buttonSmall = Font.custom(ubuntuMedium, size: 14)
}

extension Font {
    static let theme = AppFonts.self
}

class FontLoader {
    static func loadFonts() {
        let fontNames = [
            "Ubuntu-Regular",
            "Ubuntu-Bold",
            "Ubuntu-Medium",
            "Ubuntu-Light",
            "Ubuntu-Italic",
            "Ubuntu-BoldItalic",
            "Ubuntu-MediumItalic",
            "Ubuntu-LightItalic"
        ]
        
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
                print("Failed to register font: \(fontName)")
                if let error = error {
                    print("Error: \(error.takeUnretainedValue())")
                }
            } else {
                print("Successfully registered font: \(fontName)")
            }
        }
    }
}
