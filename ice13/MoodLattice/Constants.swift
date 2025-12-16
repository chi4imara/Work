import Foundation
import SwiftUI

struct Constants {
    
    struct App {
        static let name = "MoodLattice"
        static let version = "1.0.0"
        static let supportEmail = "support@moodlattice.com"
    }
    
    struct UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let moodEntries = "mood_entries"
        static let appLaunchCount = "app_launch_count"
    }
    
    struct URLs {
        static let termsOfUse = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let licenseAgreement = "https://google.com"
        static let contactUs = "https://google.com"
        static let helpFAQ = "https://google.com"
    }
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 3.0
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 15
        static let shadowRadius: CGFloat = 8
        static let padding: CGFloat = 20
        static let smallPadding: CGFloat = 10
        static let buttonHeight: CGFloat = 50
        static let tabBarHeight: CGFloat = 80
    }
    
    struct FontSize {
        static let small: CGFloat = 12
        static let regular: CGFloat = 16
        static let medium: CGFloat = 18
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 28
        static let title: CGFloat = 32
    }
}

extension MoodType {
    static let displayOrder: [MoodType] = [.happy, .calm, .neutral, .sad, .angry]
    
    var systemImageName: String {
        switch self {
        case .happy: return "face.smiling"
        case .calm: return "face.smiling"
        case .neutral: return "face.dashed"
        case .sad: return "face.dashed"
        case .angry: return "face.dashed"
        }
    }
}
