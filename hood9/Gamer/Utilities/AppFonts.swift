import SwiftUI

struct AppFonts {
    static func regular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    static func medium(size: CGFloat) -> Font {
        return Font.custom("Poppins-Medium", size: size)
    }
    
    static func semiBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-SemiBold", size: size)
    }
    
    static func bold(size: CGFloat) -> Font {
        return Font.custom("Poppins-Bold", size: size)
    }
    
    static func light(size: CGFloat) -> Font {
        return Font.custom("Poppins-Light", size: size)
    }
}

extension Font {
    static func registerFonts() {
        let fontNames = ["Poppins-Regular", "Poppins-Medium", "Poppins-SemiBold", "Poppins-Bold", "Poppins-Light"]
        
        for fontName in fontNames {
            guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf"),
                  let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
                  let font = CGFont(fontDataProvider) else {
                continue
            }
            
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterGraphicsFont(font, &error)
        }
    }
}

