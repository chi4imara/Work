import SwiftUI

struct AppFonts {
    private static let nunitoRegular = "Nunito-Regular"
    private static let nunitoMedium = "Nunito-Medium"
    private static let nunitoSemiBold = "Nunito-SemiBold"
    private static let nunitoBold = "Nunito-Bold"
    
    static let largeTitle = Font.custom(nunitoBold, size: 34)
    static let title1 = Font.custom(nunitoBold, size: 28)
    static let title2 = Font.custom(nunitoBold, size: 22)
    static let title3 = Font.custom(nunitoSemiBold, size: 20)
    
    static let headline = Font.custom(nunitoSemiBold, size: 17)
    static let body = Font.custom(nunitoRegular, size: 17)
    static let bodyMedium = Font.custom(nunitoMedium, size: 17)
    static let callout = Font.custom(nunitoRegular, size: 16)
    static let subheadline = Font.custom(nunitoRegular, size: 15)
    static let footnote = Font.custom(nunitoRegular, size: 13)
    static let caption1 = Font.custom(nunitoRegular, size: 12)
    static let caption2 = Font.custom(nunitoRegular, size: 11)
    
    static let buttonLarge = Font.custom(nunitoSemiBold, size: 18)
    static let buttonMedium = Font.custom(nunitoSemiBold, size: 16)
    static let buttonSmall = Font.custom(nunitoMedium, size: 14)
    
    static func registerFonts() {
        registerFont(bundle: Bundle.main, fontName: "Nunito-Regular", fontExtension: "ttf")
        registerFont(bundle: Bundle.main, fontName: "Nunito-Medium", fontExtension: "ttf")
        registerFont(bundle: Bundle.main, fontName: "Nunito-SemiBold", fontExtension: "ttf")
        registerFont(bundle: Bundle.main, fontName: "Nunito-Bold", fontExtension: "ttf")
    }
    
    private static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
            if let fontData = NSData(contentsOf: fontURL) {
                if let provider = CGDataProvider(data: fontData) {
                    if let font = CGFont(provider) {
                        var error: Unmanaged<CFError>?
                        if CTFontManagerRegisterGraphicsFont(font, &error) {
                            print("Successfully loaded font: \(fontName)")
                        }
                    }
                }
            }
        }
    }
}
