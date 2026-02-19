import CoreText
import SwiftUI

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func reg() {
        let fontFiles = [
            "PlayfairDisplay-Bold",
            "PlayfairDisplay-Regular",
            "PlayfairDisplay-Black"
        ]
        
        for fileName in fontFiles {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "ttf") {
                var error: Unmanaged<CFError>?
                CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            }
        }
    }
}

extension Font {
    static func bellGothic(size: CGFloat, weight: FontWeight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .bold:
            fontName = "PlayfairDisplay-Bold"
        case .black:
            fontName = "PlayfairDisplay-Black"
        default:
            fontName = "PlayfairDisplay-Regular"
        }
        
        if let font = UIFont(name: fontName, size: size) {
            return Font(font)
        } else {
            return .system(size: size, weight: weight == .bold ? .bold : (weight == .black ? .black : .regular))
        }
    }
}

enum FontWeight {
    case regular, bold, black
}
