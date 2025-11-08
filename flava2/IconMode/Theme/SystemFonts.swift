import SwiftUI

struct SystemAppFonts {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
    static let title1 = Font.system(size: 28, weight: .bold, design: .default)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .default)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
    static let headline = Font.system(size: 17, weight: .medium, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
    static let callout = Font.system(size: 16, weight: .regular, design: .default)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
    static let footnote = Font.system(size: 13, weight: .regular, design: .default)
    static let caption1 = Font.system(size: 12, weight: .light, design: .default)
    static let caption2 = Font.system(size: 11, weight: .light, design: .default)
    
    static let pixelTitle = Font.system(size: 24, weight: .heavy, design: .monospaced)
    static let pixelButton = Font.system(size: 16, weight: .bold, design: .monospaced)
    static let pixelCaption = Font.system(size: 14, weight: .medium, design: .monospaced)
}

struct FontHelper {
    static func getFont(_ fontName: String, size: CGFloat) -> Font {
        if FontRegistration.isFontRegistered(fontName) {
            return Font.custom(fontName, size: size)
        } else {
            let weight: Font.Weight
            if fontName.contains("Thin") || fontName.contains("Light") {
                weight = .light
            } else if fontName.contains("Medium") {
                weight = .medium
            } else if fontName.contains("SemiBold") {
                weight = .semibold
            } else if fontName.contains("Bold") {
                weight = .bold
            } else if fontName.contains("ExtraBold") {
                weight = .heavy
            } else {
                weight = .regular
            }
            
            if fontName.contains("pixel") {
                return Font.system(size: size, weight: weight, design: .monospaced)
            } else {
                return Font.system(size: size, weight: weight, design: .default)
            }
        }
    }
}
