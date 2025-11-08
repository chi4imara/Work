import Foundation
import SwiftUI

struct AppConstants {
    static let appName = "HobbyRadar"
    static let appVersion = "1.0.0"
    static let appBuildNumber = "1"
    
    struct UserDefaultsKeys {
        static let hasLaunchedBefore = "HasLaunchedBefore"
        static let hasSeenOnboarding = "HasSeenOnboarding"
        static let savedIdeas = "SavedIdeas"
        static let favoriteIdeas = "FavoriteIdeas"
        static let ideaHistory = "IdeaHistory"
        static let customCategories = "CustomCategories"
        static let lastSelectedTab = "LastSelectedTab"
        static let appLaunchCount = "AppLaunchCount"
    }
    
    struct Limits {
        static let maxIdeaDescriptionLength = 300
        static let maxHistoryEntries = 50
        static let maxRecentHistoryDisplay = 10
        static let maxCategoryNameLength = 30
        static let minIdeaTitleLength = 1
        static let maxIdeaTitleLength = 100
    }
    
    struct AnimationDurations {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
        static let splash: Double = 3.0
        static let tabTransition: Double = 0.4
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 16
        static let smallCornerRadius: CGFloat = 8
        static let largeCornerRadius: CGFloat = 24
        static let buttonHeight: CGFloat = 56
        static let smallButtonHeight: CGFloat = 44
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
        static let itemSpacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 24
    }
    
    struct URLs {
        static let termsAndConditions = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let licenseAgreement = "https://google.com"
        static let contactSupport = "https://google.com"
        static let emailSupport = "https://google.com"
        static let appStoreURL = "https://apps.apple.com/app/id123456789"
    }
    
    struct SystemImages {
        static let dice = "dice"
        static let diceFill = "dice.fill"
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let books = "books.vertical"
        static let booksFill = "books.vertical.fill"
        static let gear = "gearshape"
        static let gearFill = "gearshape.fill"
        static let plus = "plus"
        static let ellipsis = "ellipsis"
        static let star = "star"
        static let starFill = "star.fill"
        static let lightbulb = "lightbulb"
        static let lightbulbFill = "lightbulb.fill"
        static let sparkles = "sparkles"
        static let infinity = "infinity"
        static let magnifyingGlass = "magnifyingglass"
        static let xmark = "xmark"
        static let checkmark = "checkmark"
        static let chevronRight = "chevron.right"
        static let chevronDown = "chevron.down"
        static let arrowRight = "arrow.right"
        static let pencil = "pencil"
        static let trash = "trash"
        static let eye = "eye"
        static let envelope = "envelope"
        static let lock = "lock.shield"
        static let doc = "doc.text"
        static let calendar = "calendar"
        static let person = "person"
        static let exclamationTriangle = "exclamationmark.triangle"
        static let arrowClockwise = "arrow.clockwise"
    }
    
    struct NotificationNames {
        static let ideaAdded = Notification.Name("IdeaAdded")
        static let ideaUpdated = Notification.Name("IdeaUpdated")
        static let ideaDeleted = Notification.Name("IdeaDeleted")
        static let favoriteToggled = Notification.Name("FavoriteToggled")
        static let historyUpdated = Notification.Name("HistoryUpdated")
    }
    
    struct ErrorMessages {
        static let emptyTitle = "Please enter an idea title"
        static let titleTooLong = "Title is too long. Please keep it under \(Limits.maxIdeaTitleLength) characters."
        static let descriptionTooLong = "Description is too long. Please keep it under \(Limits.maxIdeaDescriptionLength) characters."
        static let emptyCategoryName = "Category name cannot be empty"
        static let categoryExists = "A category with this name already exists"
        static let categoryNameTooLong = "Category name is too long. Please keep it under \(Limits.maxCategoryNameLength) characters."
        static let noIdeasAvailable = "No ideas available. Add some ideas to get started."
        static let ideaNotFound = "Idea not found. It may have been deleted."
        static let networkError = "Network error. Please check your connection and try again."
        static let unknownError = "An unknown error occurred. Please try again."
    }
    
    struct SuccessMessages {
        static let ideaSaved = "Idea saved successfully"
        static let ideaDeleted = "Idea deleted successfully"
        static let addedToFavorites = "Added to favorites"
        static let removedFromFavorites = "Removed from favorites"
        static let categorySaved = "Category saved successfully"
        static let historyCleared = "History cleared successfully"
        static let favoritesCleared = "Favorites cleared successfully"
    }
    
    struct Placeholders {
        static let ideaTitle = "Enter your idea..."
        static let ideaDescription = "Add a description (optional)..."
        static let ideaSource = "e.g., Book title, website, etc. (optional)"
        static let categoryName = "Enter category name..."
        static let searchIdeas = "Search ideas..."
        static let selectCategory = "Select Category"
    }
    
    struct ButtonTitles {
        static let save = "Save"
        static let cancel = "Cancel"
        static let delete = "Delete"
        static let edit = "Edit"
        static let done = "Done"
        static let close = "Close"
        static let back = "Back"
        static let next = "Next"
        static let skip = "Skip"
        static let continue_ = "Continue"
        static let getStarted = "Get Started"
        static let tryAgain = "Try Again"
        static let addIdea = "Add Idea"
        static let generateNewIdea = "Generate New Idea"
        static let viewDetails = "View Details"
        static let addToFavorites = "Add to Favorites"
        static let removeFromFavorites = "Remove from Favorites"
        static let clearAll = "Clear All"
        static let applyFilters = "Apply Filters"
        static let clearFilters = "Clear Filters"
        static let rateApp = "Rate Our App"
        static let contactUs = "Contact Us"
    }
    
    struct ScreenTitles {
        static let home = "Idea for Leisure"
        static let allIdeas = "All Ideas"
        static let favorites = "Favorites"
        static let settings = "Settings"
        static let newIdea = "New Idea"
        static let editIdea = "Edit Idea"
        static let ideaDetails = "Idea Details"
        static let filters = "Filters & Sorting"
        static let newCategory = "New Category"
    }
}

struct AppConfig {
    static let targetIOSVersion = "16.0"
    static let supportedOrientations: [UIInterfaceOrientation] = [.portrait]
    static let supportsLandscape = false
    static let supportsDarkMode = false
    
    static let enableHapticFeedback = true
    static let enableAnimations = true
    static let enableAnalytics = false
    static let enableCrashReporting = false
    
    static let maxConcurrentOperations = 3
    static let cacheSize = 50
    static let backgroundTaskTimeout: TimeInterval = 30
}

#if DEBUG
struct DebugConfig {
    static let enableLogging = true
    static let logLevel = "DEBUG"
    static let showPerformanceMetrics = false
    static let enableMemoryWarnings = true
}
#endif
