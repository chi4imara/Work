import Foundation

struct Constants {
    struct UserDefaults {
        static let hasSeenOnboarding = "HasSeenOnboarding"
        static let savedShoes = "SavedShoes"
        static let savedNotes = "SavedNotes"
    }
    
    struct Animation {
        static let defaultDuration: Double = 0.3
        static let splashDuration: Double = 3.0
    }
    
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
    }
    
    struct Limits {
        static let maxNotePreviewLength = 100
        static let maxCommentLines = 6
        static let minCommentLines = 3
    }
}
