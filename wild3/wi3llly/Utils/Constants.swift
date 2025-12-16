import Foundation
import SwiftUI

struct Constants {
    
    struct App {
        static let name = "Dream Journal"
        static let version = "1.0.0"
        static let build = "1"
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let buttonHeight: CGFloat = 48
        static let tabBarHeight: CGFloat = 80
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
    }
    
    struct Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 2.5
    }
    
    struct FontSize {
        static let small: CGFloat = 12
        static let body: CGFloat = 16
        static let title: CGFloat = 20
        static let largeTitle: CGFloat = 28
        static let hero: CGFloat = 34
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct IconSize {
        static let small: CGFloat = 16
        static let medium: CGFloat = 24
        static let large: CGFloat = 32
        static let extraLarge: CGFloat = 48
    }
    
    struct Grid {
        static let size: CGFloat = 30
        static let opacity: Double = 0.1
    }
    
    struct Limits {
        static let maxTitleLength = 100
        static let maxContentLength = 5000
        static let maxTagLength = 30
        static let maxTagsPerDream = 10
        static let statisticsMinDreams = 2
        static let recentDaysCount = 30
        static let maxFrequentTags = 10
        static let maxChartTags = 5
    }
    
    struct URLs {
        static let termsAndConditions = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let contactUs = "https://google.com"
        static let support = "https://google.com"
    }
    
    struct UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let appLaunchCount = "appLaunchCount"
        static let lastAppVersion = "lastAppVersion"
    }
    
    struct CoreData {
        static let modelName = "DreamModel"
        static let dreamEntityName = "Dream"
        static let tagEntityName = "Tag"
    }
    
    struct Accessibility {
        static let dreamCardIdentifier = "dreamCard"
        static let tagBadgeIdentifier = "tagBadge"
        static let addButtonIdentifier = "addButton"
        static let filterButtonIdentifier = "filterButton"
        static let settingsButtonIdentifier = "settingsButton"
    }
}
