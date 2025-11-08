import SwiftUI

struct FontManager {
    enum PoppinsWeight: String {
        case light = "Poppins-Light"
        case regular = "Poppins-Regular"
        case medium = "Poppins-Medium"
        case semiBold = "Poppins-SemiBold"
        case bold = "Poppins-Bold"
    }
    
    static func poppins(_ weight: PoppinsWeight, size: CGFloat) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
    
    static let largeTitle = poppins(.bold, size: 28)
    static let title = poppins(.semiBold, size: 22)
    static let title2 = poppins(.semiBold, size: 20)
    static let title3 = poppins(.medium, size: 18)
    static let headline = poppins(.semiBold, size: 16)
    static let body = poppins(.regular, size: 16)
    static let callout = poppins(.regular, size: 14)
    static let subheadline = poppins(.medium, size: 14)
    static let footnote = poppins(.regular, size: 12)
    static let caption = poppins(.light, size: 11)
}
