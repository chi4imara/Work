import SwiftUI

struct Theme {
    struct Colors {
        static let primary = Color.blue
        static let secondary = Color.yellow
        static let accent = Color.orange
        static let background = Color.white
        static let text = Color.blue
        static let textSecondary = Color.gray
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        
        static let bubbleBlue = Color.blue.opacity(0.6)
        static let bubbleLight = Color.cyan.opacity(0.4)
        static let bubbleDark = Color.indigo.opacity(0.5)
    }
    
    struct Fonts {
        static func playfairRegular(size: CGFloat) -> Font {
            return Font.custom("PlayfairDisplay-Regular", size: size)
        }
        
        static func playfairMedium(size: CGFloat) -> Font {
            return Font.custom("PlayfairDisplay-Medium", size: size)
        }
        
        static func playfairBold(size: CGFloat) -> Font {
            return Font.custom("PlayfairDisplay-Bold", size: size)
        }
        
        static func playfairSemiBold(size: CGFloat) -> Font {
            return Font.custom("PlayfairDisplay-SemiBold", size: size)
        }
        
        static func playfairItalic(size: CGFloat) -> Font {
            return Font.custom("PlayfairDisplay-Italic", size: size)
        }
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let circle: CGFloat = 50
    }
    
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let medium = SwiftUI.Animation.easeInOut(duration: 0.4)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.6)
        static let bounce = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.6)
    }
}
