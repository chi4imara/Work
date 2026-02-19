import SwiftUI

extension Font {
    static func playfairDisplay(_ style: PlayfairDisplayStyle, size: CGFloat) -> Font {
        return .custom(style.fontName, size: size)
    }
}

enum PlayfairDisplayStyle {
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black
    case italic
    case mediumItalic
    case semiBoldItalic
    case boldItalic
    case extraBoldItalic
    case blackItalic
    
    var fontName: String {
        switch self {
        case .regular:
            return "PlayfairDisplay-Regular"
        case .medium:
            return "PlayfairDisplay-Medium"
        case .semiBold:
            return "PlayfairDisplay-SemiBold"
        case .bold:
            return "PlayfairDisplay-Bold"
        case .extraBold:
            return "PlayfairDisplay-ExtraBold"
        case .black:
            return "PlayfairDisplay-Black"
        case .italic:
            return "PlayfairDisplay-Italic"
        case .mediumItalic:
            return "PlayfairDisplay-MediumItalic"
        case .semiBoldItalic:
            return "PlayfairDisplay-SemiBoldItalic"
        case .boldItalic:
            return "PlayfairDisplay-BoldItalic"
        case .extraBoldItalic:
            return "PlayfairDisplay-ExtraBoldItalic"
        case .blackItalic:
            return "PlayfairDisplay-BlackItalic"
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
