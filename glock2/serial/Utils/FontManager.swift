import SwiftUI

extension Font {
    static func poppinsLight(_ size: CGFloat) -> Font {
        return Font.custom("Poppins-Light", size: size)
    }
    
    static func poppinsRegular(_ size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    static func poppinsMedium(_ size: CGFloat) -> Font {
        return Font.custom("Poppins-Medium", size: size)
    }
    
    static func poppinsSemiBold(_ size: CGFloat) -> Font {
        return Font.custom("Poppins-SemiBold", size: size)
    }
    
    static func poppinsBold(_ size: CGFloat) -> Font {
        return Font.custom("Poppins-Bold", size: size)
    }
    
    static let titleLarge = Font.poppinsBold(28)
    static let titleMedium = Font.poppinsSemiBold(22)
    static let titleSmall = Font.poppinsMedium(18)
    
    static let bodyLarge = Font.poppinsRegular(16)
    static let bodyMedium = Font.poppinsRegular(14)
    static let bodySmall = Font.poppinsRegular(12)
    
    static let captionMedium = Font.poppinsMedium(12)
    static let captionSmall = Font.poppinsLight(10)
}
