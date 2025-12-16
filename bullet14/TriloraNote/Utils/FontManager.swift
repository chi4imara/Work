import SwiftUI

struct FontManager {
    static func registerFonts() {
        let fontNames = [
            "Ubuntu-Regular",
            "Ubuntu-Bold",
            "Ubuntu-Light",
            "Ubuntu-Medium",
            "Ubuntu-Italic",
            "Ubuntu-BoldItalic",
            "Ubuntu-LightItalic",
            "Ubuntu-MediumItalic"
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

extension Font {
    static func ubuntu(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Ubuntu-Light", size: size)
        case .medium:
            return .custom("Ubuntu-Medium", size: size)
        case .bold:
            return .custom("Ubuntu-Bold", size: size)
        default:
            return .custom("Ubuntu-Regular", size: size)
        }
    }
    
    static func ubuntuItalic(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Ubuntu-LightItalic", size: size)
        case .medium:
            return .custom("Ubuntu-MediumItalic", size: size)
        case .bold:
            return .custom("Ubuntu-BoldItalic", size: size)
        default:
            return .custom("Ubuntu-Italic", size: size)
        }
    }
}
