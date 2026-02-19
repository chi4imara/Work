import SwiftUI

struct ColorTheme {
    static let backgroundColor = Color.white
    static let textColor = Color(red: 0.25, green: 0.45, blue: 0.85)
    static let accentColor = Color(red: 0.95, green: 0.78, blue: 0.2)
    static let secondaryColor = Color(red: 0.25, green: 0.45, blue: 0.85).opacity(0.6)
    static let cardBackground = Color.white.opacity(0.9)
    static let shadowColor = Color.black.opacity(0.1)
    
    private static let blueLight = Color(red: 0.6, green: 0.78, blue: 0.98)
    private static let blueMid = Color(red: 0.4, green: 0.65, blue: 0.92)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            blueLight.opacity(0.4),
            blueMid.opacity(0.15),
            blueLight.opacity(0.3),
            Color.white
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white,
            blueLight.opacity(0.25),
            Color(red: 0.95, green: 0.78, blue: 0.2).opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Font {
    static func playfair(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .black:
            return .custom("PlayfairDisplay-Black", size: size)
        case .bold:
            return .custom("PlayfairDisplay-Bold", size: size)
        case .semibold:
            return .custom("PlayfairDisplay-SemiBold", size: size)
        case .medium:
            return .custom("PlayfairDisplay-Medium", size: size)
        default:
            return .custom("PlayfairDisplay-Regular", size: size)
        }
    }
}
