import Foundation
import SwiftUI

struct Constants {
    
    struct App {
        static let name = "RelaxMe"
        static let version = "1.0.0"
        static let supportEmail = "support@relaxme.com"
        static let privacyPolicyURL = "https://google.com"
        static let termsOfServiceURL = "https://google.com"
    }
    
    struct Animation {
        static let short: Double = 0.3
        static let medium: Double = 0.5
        static let long: Double = 1.0
        static let splash: Double = 2.0
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 40
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 20
        static let button: CGFloat = 25
    }
    
    struct Shadow {
        static let small: CGFloat = 2
        static let medium: CGFloat = 5
        static let large: CGFloat = 8
        static let xlarge: CGFloat = 10
    }
    
    struct FontSize {
        static let caption: CGFloat = 10
        static let small: CGFloat = 12
        static let body: CGFloat = 14
        static let title3: CGFloat = 16
        static let title2: CGFloat = 18
        static let title1: CGFloat = 20
        static let headline: CGFloat = 24
        static let largeTitle: CGFloat = 28
        static let hero: CGFloat = 32
    }
    
    struct Layout {
        static let buttonHeight: CGFloat = 50
        static let tabBarHeight: CGFloat = 80
        static let cardMinHeight: CGFloat = 120
        static let avatarSize: CGFloat = 60
        static let iconSize: CGFloat = 24
    }
    
    struct UserDefaultsKeys {
        static let onboardingCompleted = "onboardingCompleted"
        static let userPreferences = "userPreferences"
        static let lastStressLevel = "lastStressLevel"
    }
    
}
