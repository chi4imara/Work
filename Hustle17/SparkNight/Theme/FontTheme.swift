import SwiftUI

struct FontTheme {
    static func poppinsRegular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    static func poppinsLight(size: CGFloat) -> Font {
        return Font.custom("Poppins-Light", size: size)
    }
    
    static func poppinsMedium(size: CGFloat) -> Font {
        return Font.custom("Poppins-Medium", size: size)
    }
    
    static func poppinsSemiBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-SemiBold", size: size)
    }
    
    static func poppinsBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-Bold", size: size)
    }
    
    static let largeTitle = poppinsBold(size: 34)
    static let title1 = poppinsBold(size: 28)
    static let title2 = poppinsSemiBold(size: 22)
    static let title3 = poppinsSemiBold(size: 20)
    static let headline = poppinsSemiBold(size: 17)
    static let body = poppinsRegular(size: 17)
    static let callout = poppinsRegular(size: 16)
    static let subheadline = poppinsRegular(size: 15)
    static let footnote = poppinsRegular(size: 13)
    static let caption1 = poppinsRegular(size: 12)
    static let caption2 = poppinsRegular(size: 11)
}

extension Font {
    static let theme = FontTheme.self
}
