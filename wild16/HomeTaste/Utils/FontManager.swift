import SwiftUI
import CoreText
import CoreGraphics

struct FontManager {
    private static let playfairRegular = "PlayfairDisplay-Regular"
    private static let playfairBold = "PlayfairDisplay-Bold"
    private static let playfairItalic = "PlayfairDisplay-Italic"
    private static let playfairBoldItalic = "PlayfairDisplay-BoldItalic"
    
    static func playfairRegular(size: CGFloat) -> Font {
        return Font.custom(playfairRegular, size: size)
    }
    
    static func playfairBold(size: CGFloat) -> Font {
        return Font.custom(playfairBold, size: size)
    }
    
    static func playfairItalic(size: CGFloat) -> Font {
        return Font.custom(playfairItalic, size: size)
    }
    
    static func playfairBoldItalic(size: CGFloat) -> Font {
        return Font.custom(playfairBoldItalic, size: size)
    }
    
    static let largeTitle = playfairBold(size: 34)
    static let title1 = playfairBold(size: 28)
    static let title2 = playfairBold(size: 22)
    static let title3 = playfairBold(size: 20)
    static let headline = playfairBold(size: 17)
    static let body = playfairRegular(size: 17)
    static let callout = playfairRegular(size: 16)
    static let subheadline = playfairRegular(size: 15)
    static let footnote = playfairRegular(size: 13)
    static let caption1 = playfairRegular(size: 12)
    static let caption2 = playfairRegular(size: 11)
    
    static func loadFonts() {
        let fontNames = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Bold", 
            "PlayfairDisplay-Italic",
            "PlayfairDisplay-BoldItalic"
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
            }
        }
    }
}
