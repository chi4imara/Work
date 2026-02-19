import SwiftUI

struct AppConstants {
    static let smallSpacing: CGFloat = 8
    static let mediumSpacing: CGFloat = 16
    static let largeSpacing: CGFloat = 24
    static let extraLargeSpacing: CGFloat = 32
    
    static let smallCornerRadius: CGFloat = 8
    static let mediumCornerRadius: CGFloat = 12
    static let largeCornerRadius: CGFloat = 16
    static let extraLargeCornerRadius: CGFloat = 24
    
    static let smallFontSize: CGFloat = 12
    static let mediumFontSize: CGFloat = 16
    static let largeFontSize: CGFloat = 20
    static let titleFontSize: CGFloat = 24
    static let headerFontSize: CGFloat = 28
    
    static let buttonHeight: CGFloat = 50
    static let smallButtonHeight: CGFloat = 40
    static let largeButtonHeight: CGFloat = 60
    
    static let cardMinHeight: CGFloat = 80
    static let cardPadding: CGFloat = 16
    
    static let shortAnimation: Double = 0.2
    static let mediumAnimation: Double = 0.3
    static let longAnimation: Double = 0.5
    
    static let tabBarHeight: CGFloat = 80
    static let tabBarIconSize: CGFloat = 24
    
    static let lowPriorityColor = Color.green
    static let mediumPriorityColor = Color.yellow
    static let highPriorityColor = Color.red
}

enum AppFontWeight: String, CaseIterable {
    case light = "Ubuntu-Light"
    case regular = "Ubuntu-Regular"
    case medium = "Ubuntu-Medium"
    case semiBold = "Ubuntu-Italic" 
    case bold = "Ubuntu-Bold"
}

extension Font {
    static func ubuntu(_ weight: AppFontWeight, size: CGFloat) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
}
