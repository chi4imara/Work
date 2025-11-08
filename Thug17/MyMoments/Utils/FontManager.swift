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
    
    static let appTitle = Font.nunitoBold(size: 28)
    static let screenTitle = Font.nunitoBold(size: 24)
    static let cardTitle = Font.nunitoSemiBold(size: 18)
    static let bodyText = Font.nunitoRegular(size: 16)
    static let caption = Font.nunitoRegular(size: 14)
    static let smallCaption = Font.nunitoRegular(size: 12)
    static let buttonText = Font.nunitoMedium(size: 16)
}
