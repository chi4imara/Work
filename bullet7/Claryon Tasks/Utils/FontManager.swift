import SwiftUI

extension Font {
    static func builderSans(_ weight: BuilderSansWeight, size: CGFloat) -> Font {
        let fontName = weight.fontName
        if FontHelper.shared.isFontAvailable(fontName) {
            return Font.custom(fontName, size: size)
        } else {
            print("⚠️ Font \(fontName) not found, using system font")
            return Font.system(size: size, weight: weight.systemWeight)
        }
    }
    
    static let titleLarge = Font.builderSans(.bold, size: 28)
    static let titleMedium = Font.builderSans(.semiBold, size: 22)
    static let titleSmall = Font.builderSans(.semiBold, size: 18)
    static let bodyLarge = Font.builderSans(.medium, size: 16)
    static let bodyMedium = Font.builderSans(.regular, size: 14)
    static let bodySmall = Font.builderSans(.regular, size: 12)
    static let caption = Font.builderSans(.light, size: 10)
}

enum BuilderSansWeight {
    case thin
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    
    var fontName: String {
        switch self {
        case .thin:
            return "BuilderSans-Thin-100"
        case .light:
            return "BuilderSans-Light-300"
        case .regular:
            return "BuilderSans-Regular-400"
        case .medium:
            return "BuilderSans-Medium-500"
        case .semiBold:
            return "BuilderSans-SemiBold-600"
        case .bold:
            return "BuilderSans-Bold-700"
        case .extraBold:
            return "BuilderSans-ExtraBold-800"
        }
    }
    
    var systemWeight: Font.Weight {
        switch self {
        case .thin:
            return .thin
        case .light:
            return .light
        case .regular:
            return .regular
        case .medium:
            return .medium
        case .semiBold:
            return .semibold
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        }
    }
}
