import SwiftUI

extension Font {
    static func playfairRegular(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-Regular", size: size)
    }
    
    static func playfairMedium(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-Medium", size: size)
    }
    
    static func playfairBold(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-Bold", size: size)
    }
    
    static func playfairSemiBold(size: CGFloat) -> Font {
        return .custom("PlayfairDisplay-SemiBold", size: size)
    }
    
    static let appTitle = playfairBold(size: 28)
    static let screenTitle = playfairBold(size: 24)
    static let cardTitle = playfairSemiBold(size: 18)
    static let bodyText = playfairRegular(size: 16)
    static let caption = playfairRegular(size: 14)
    static let smallCaption = playfairRegular(size: 11)
    static let buttonText = playfairMedium(size: 16)
}
