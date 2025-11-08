import SwiftUI

struct AppFonts {
    private static let playfairRegular = "PlayfairDisplay-Regular"
    private static let playfairBold = "PlayfairDisplay-Bold"
    private static let playfairMedium = "PlayfairDisplay-Medium"
    private static let playfairSemiBold = "PlayfairDisplay-SemiBold"
    private static let playfairItalic = "PlayfairDisplay-Italic"
    
    static let largeTitle = Font.custom(playfairBold, size: 34) ?? Font.largeTitle.weight(.bold)
    static let title1 = Font.custom(playfairBold, size: 28) ?? Font.title.weight(.bold)
    static let title2 = Font.custom(playfairSemiBold, size: 22) ?? Font.title2.weight(.semibold)
    static let title3 = Font.custom(playfairSemiBold, size: 20) ?? Font.title3.weight(.semibold)
    
    static let headline = Font.custom(playfairSemiBold, size: 17) ?? Font.headline.weight(.semibold)
    static let body = Font.custom(playfairRegular, size: 17) ?? Font.body
    static let bodyMedium = Font.custom(playfairMedium, size: 17) ?? Font.body.weight(.medium)
    static let callout = Font.custom(playfairRegular, size: 16) ?? Font.callout
    static let subheadline = Font.custom(playfairRegular, size: 15) ?? Font.subheadline
    static let footnote = Font.custom(playfairRegular, size: 13) ?? Font.footnote
    static let caption = Font.custom(playfairRegular, size: 12) ?? Font.caption
    static let caption2 = Font.custom(playfairRegular, size: 11) ?? Font.caption2
    
    static let italic = Font.custom(playfairItalic, size: 17) ?? Font.body.italic()
    static let buttonText = Font.custom(playfairSemiBold, size: 16) ?? Font.body.weight(.semibold)
    
    static func registerFonts() {
        print("🎨 Starting font registration...")
        
        let mainFonts = [
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-Medium", 
            "PlayfairDisplay-SemiBold",
            "PlayfairDisplay-Italic"
        ]
        
        var registeredCount = 0
        
        for font in mainFonts {
            if let url = Bundle.main.url(forResource: font, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                let _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
        
        print("🎨 Font registration complete: \(registeredCount)/\(mainFonts.count) fonts registered")
        
        if registeredCount == 0 {
            print("⚠️ No custom fonts registered - using system fonts as fallback")
        }
    }
    
    private static func registerFontFromURL(_ fontURL: URL, name: String) -> Bool {
        guard let fontData = NSData(contentsOf: fontURL),
              let dataProvider = CGDataProvider(data: fontData),
              let font = CGFont(dataProvider) else {
            return false
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if !success {
            print("❌ Failed to register \(name): \(String(describing: error))")
        }
        
        return success
    }
}

extension Font {
    static let theme = AppFonts.self
}
