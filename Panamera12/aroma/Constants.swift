import Foundation
import SwiftUI
import Combine

struct AppConstants {
    
    static let appName = "Fragrance Archive"
    static let appVersion = "1.0.0"
    static let supportEmail = "support@fragrancearchive.com"
    
    static let privacyPolicyURL = "https://google.com"
    static let supportURL = "https://google.com"
    static let feedbackURL = "https://google.com"
    
    struct UserDefaultsKeys {
        static let hasSeenOnboarding = "HasSeenOnboarding"
        static let savedFragrances = "SavedFragrances"
        static let appLaunchCount = "AppLaunchCount"
        static let lastAppVersion = "LastAppVersion"
    }
    
    struct AnimationDurations {
        static let splash: Double = 2.5
        static let transition: Double = 0.5
        static let buttonPress: Double = 0.1
        static let cardAnimation: Double = 0.3
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let smallCornerRadius: CGFloat = 8
        static let buttonHeight: CGFloat = 50
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 24
    }
    
    struct FontSizes {
        static let title: CGFloat = 28
        static let headline: CGFloat = 22
        static let body: CGFloat = 16
        static let caption: CGFloat = 14
        static let small: CGFloat = 12
    }
    
    struct SystemImages {
        static let plus = "plus"
        static let heart = "heart"
        static let heartFilled = "heart.fill"
        static let search = "magnifyingglass"
        static let settings = "gearshape"
        static let sparkles = "sparkles"
        static let calendar = "calendar"
        static let clock = "clock"
        static let leaf = "leaf"
        static let note = "note.text"
        static let trash = "trash"
        static let pencil = "pencil"
        static let xmark = "xmark"
        static let chevronDown = "chevron.down"
        static let chevronLeft = "chevron.left"
        static let star = "star.fill"
        static let envelope = "envelope.fill"
        static let shield = "shield.checkered"
        static let info = "info.circle.fill"
        static let question = "questionmark.circle.fill"
        static let globe = "globe"
    }
    
    struct Validation {
        static let maxFragranceNameLength = 100
        static let maxNotesLength = 500
        static let maxOccasionsLength = 200
        static let maxPersonalNotesLength = 1000
    }
}

class AppState: ObservableObject {
    @Published var isFirstLaunch: Bool = false
    @Published var launchCount: Int = 0
    
    init() {
        checkFirstLaunch()
        incrementLaunchCount()
    }
    
    private func checkFirstLaunch() {
        let lastVersion = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.lastAppVersion)
        isFirstLaunch = lastVersion != AppConstants.appVersion
        
        if isFirstLaunch {
            UserDefaults.standard.set(AppConstants.appVersion, forKey: AppConstants.UserDefaultsKeys.lastAppVersion)
        }
    }
    
    private func incrementLaunchCount() {
        launchCount = UserDefaults.standard.integer(forKey: AppConstants.UserDefaultsKeys.appLaunchCount)
        launchCount += 1
        UserDefaults.standard.set(launchCount, forKey: AppConstants.UserDefaultsKeys.appLaunchCount)
    }
}
