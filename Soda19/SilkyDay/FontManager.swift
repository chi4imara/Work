import Foundation
import SwiftUI
import CoreText

class FontManager {
    static let shared = FontManager()
    
    private init() {
        registerFonts()
    }
    
    private func registerFonts() {
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
            registerFont(fontName: fontName, fontExtension: "ttf")
        }
    }
    
    private func registerFont(fontName: String, fontExtension: String) {
        guard let fontURL = Bundle.main.url(forResource: fontName, withExtension: fontExtension) else {
            print("Could not find font file: \(fontName).\(fontExtension)")
            return
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        
        if !success {
            if let error = error?.takeRetainedValue() {
                print("Error registering font: \(fontName). Error: \(error)")
            } else {
                print("Error registering font: \(fontName)")
            }
        }
    }
}

extension Font {
    static func ubuntu(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .light:
            return .custom("Ubuntu-Light", size: size)
        case .regular:
            return .custom("Ubuntu-Regular", size: size)
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
        case .regular:
            return .custom("Ubuntu-Italic", size: size)
        case .medium:
            return .custom("Ubuntu-MediumItalic", size: size)
        case .bold:
            return .custom("Ubuntu-BoldItalic", size: size)
        default:
            return .custom("Ubuntu-Italic", size: size)
        }
    }
}

struct AppFonts {
    static let largeTitle = Font.ubuntu(32, weight: .bold)
    static let title1 = Font.ubuntu(28, weight: .bold)
    static let title2 = Font.ubuntu(22, weight: .bold)
    static let title3 = Font.ubuntu(20, weight: .medium)
    
    static let body = Font.ubuntu(17, weight: .regular)
    static let bodyBold = Font.ubuntu(17, weight: .bold)
    static let callout = Font.ubuntu(16, weight: .regular)
    static let subheadline = Font.ubuntu(15, weight: .regular)
    static let footnote = Font.ubuntu(13, weight: .regular)
    static let caption = Font.ubuntu(12, weight: .regular)
    static let caption2 = Font.ubuntu(11, weight: .regular)
    
    static let button = Font.ubuntu(17, weight: .medium)
    static let tabBar = Font.ubuntu(10, weight: .medium)
}
