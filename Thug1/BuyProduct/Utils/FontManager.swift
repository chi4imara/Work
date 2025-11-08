import SwiftUI

extension Font {
    static func nunitoRegular(size: CGFloat) -> Font {
        return Font.custom("Nunito-Regular", size: size)
    }
    
    static func nunitoMedium(size: CGFloat) -> Font {
        return Font.custom("Nunito-Medium", size: size)
    }
    
    static func nunitoSemiBold(size: CGFloat) -> Font {
        return Font.custom("Nunito-SemiBold", size: size)
    }
    
    static func nunitoBold(size: CGFloat) -> Font {
        return Font.custom("Nunito-Bold", size: size)
    }
    
    static let titleLarge = Font.nunitoBold(size: 24)
    static let titleMedium = Font.nunitoBold(size: 20)
    static let titleSmall = Font.nunitoSemiBold(size: 18)
    static let bodyLarge = Font.nunitoMedium(size: 16)
    static let bodyMedium = Font.nunitoRegular(size: 14)
    static let bodySmall = Font.nunitoRegular(size: 12)
    static let caption = Font.nunitoRegular(size: 10)
}
