import SwiftUI

struct FontManager {
    static func registerFonts() {
        registerFont(bundle: Bundle.main, fontName: "Nunito-Regular", fontExtension: "ttf")
        registerFont(bundle: Bundle.main, fontName: "Nunito-Medium", fontExtension: "ttf")
        registerFont(bundle: Bundle.main, fontName: "Nunito-SemiBold", fontExtension: "ttf")
        registerFont(bundle: Bundle.main, fontName: "Nunito-Bold", fontExtension: "ttf")
    }
    
    private static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
            return
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Error registering font: maybe it was already registered.")
        }
    }
}

extension Font {
    static func nunitoRegular(size: CGFloat) -> Font {
        return Font.custom("Nunito-Regular", size: size)
    }
    
    static func nunitoMedium(size: CGFloat) -> Font {
        return Font.custom("Nunito-Medium", size: size)
    }
    
    static func nunitoSemiBold(size: CGFloat) -> Font {
        return Font.custom("Nunito-SemiBold", size: size)
    }
    
    static func nunitoBold(size: CGFloat) -> Font {
        return Font.custom("Nunito-Bold", size: size)
    }
}
