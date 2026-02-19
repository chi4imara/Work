import SwiftUI

extension Font {
    static func appTitle() -> Font {
        .crimsonText(28, weight: .bold)
    }
    
    static func appHeadline() -> Font {
        .crimsonText(22, weight: .semibold)
    }
    
    static func appBody() -> Font {
        .crimsonText(16, weight: .regular)
    }
    
    static func appCaption() -> Font {
        .crimsonText(14, weight: .regular)
    }
    
    static func appButton() -> Font {
        .crimsonText(18, weight: .semibold)
    }
}
