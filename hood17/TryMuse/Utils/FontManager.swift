import SwiftUI

struct AppFonts {
    static func nunito(_ weight: NunitoWeight, size: CGFloat) -> Font {
        return Font.custom(weight.fontName, size: size)
    }
}

enum NunitoWeight {
    case regular
    case medium
    case semiBold
    case bold
    
    var fontName: String {
        switch self {
        case .regular:
            return "Nunito-Regular"
        case .medium:
            return "Nunito-Medium"
        case .semiBold:
            return "Nunito-SemiBold"
        case .bold:
            return "Nunito-Bold"
        }
    }
}

extension Font {
    static let appLargeTitle = AppFonts.nunito(.bold, size: 34)
    static let appTitle = AppFonts.nunito(.bold, size: 28)
    static let appTitle2 = AppFonts.nunito(.bold, size: 22)
    static let appTitle3 = AppFonts.nunito(.semiBold, size: 20)
    
    static let appHeadline = AppFonts.nunito(.semiBold, size: 17)
    static let appBody = AppFonts.nunito(.regular, size: 17)
    static let appCallout = AppFonts.nunito(.regular, size: 16)
    static let appSubheadline = AppFonts.nunito(.regular, size: 15)
    static let appFootnote = AppFonts.nunito(.regular, size: 13)
    static let appCaption = AppFonts.nunito(.regular, size: 12)
    static let appCaption2 = AppFonts.nunito(.regular, size: 11)
    
    static let appButton = AppFonts.nunito(.semiBold, size: 17)
    static let appNavTitle = AppFonts.nunito(.bold, size: 17)
}
