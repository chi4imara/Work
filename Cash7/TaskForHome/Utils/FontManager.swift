import SwiftUI

extension Font {
    static let customRegular = "Helvetica"
    static let customBold = "Helvetica-Bold"
    static let customLight = "Helvetica-Light"
    
    static func customTitle() -> Font {
        return .custom(customBold, size: 28)
    }
    
    static func customHeadline() -> Font {
        return .custom(customBold, size: 22)
    }
    
    static func customSubheadline() -> Font {
        return .custom(customRegular, size: 18)
    }
    
    static func customBody() -> Font {
        return .custom(customRegular, size: 16)
    }
    
    static func customCaption() -> Font {
        return .custom(customLight, size: 12)
    }
    
    static func customSmall() -> Font {
        return .custom(customLight, size: 12)
    }
}

