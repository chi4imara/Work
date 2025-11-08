import SwiftUI

extension Font {
    
    static func ralewayLight(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Light", size: size)
    }
    
    static func ralewayRegular(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Regular", size: size)
    }
    
    static func ralewayMedium(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Medium", size: size)
    }
    
    static func ralewaySemiBold(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-SemiBold", size: size)
    }
    
    static func ralewayBold(_ size: CGFloat) -> Font {
        return Font.custom("Raleway-Bold", size: size)
    }
    
    static let dreamTitle = Font.ralewayBold(28)
    static let dreamHeadline = Font.ralewaySemiBold(22)
    static let dreamSubheadline = Font.ralewayMedium(18)
    static let dreamBody = Font.ralewayRegular(16)
    static let dreamCaption = Font.ralewayLight(14)
    static let dreamSmall = Font.ralewayLight(12)
}
