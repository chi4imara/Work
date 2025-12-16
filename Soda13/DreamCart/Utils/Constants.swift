import Foundation
import SwiftUI

struct Constants {
    
    struct App {
        static let name = "Beauty Diary"
        static let version = "1.0.0"
    }
    
    struct UserDefaultsKeys {
        static let hasSeenOnboarding = "HasSeenOnboarding"
        static let beautyEntries = "BeautyEntries"
    }
    
    struct URLs {
        static let termsOfUse = "https://google.com"
        static let privacyPolicy = "https://google.com"
        static let contactUs = "https://google.com"
        static let licenseAgreement = "https://google.com"
        static let dataProtectionPolicy = "https://google.com"
    }
    
    struct Animation {
        static let splash: Double = 2.5
        static let transition: Double = 0.5
        static let button: Double = 0.2
        static let loading: Double = 1.5
    }
    
    struct Layout {
        static let cornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 20
        static let shadowRadius: CGFloat = 4
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
    }
    
    struct FontSize {
        static let title: CGFloat = 32
        static let largeTitle: CGFloat = 28
        static let headline: CGFloat = 20
        static let body: CGFloat = 16
        static let caption: CGFloat = 14
        static let small: CGFloat = 12
    }
    
    struct SystemImages {
        static let diary = "book.closed"
        static let notes = "note.text"
        static let favorites = "heart"
        static let calendar = "calendar"
        static let settings = "gearshape"
        static let plus = "plus.circle.fill"
        static let edit = "pencil"
        static let delete = "trash"
        static let chevronRight = "chevron.right"
        static let sparkles = "sparkles"
        static let star = "star.fill"
        static let heart = "heart.fill"
        static let envelope = "envelope"
        static let lock = "lock.shield"
        static let doc = "doc.text"
        static let shield = "shield.checkerboard"
        static let gear = "doc.badge.gearshape"
    }
    
    struct PlaceholderText {
        static let procedureName = "e.g., Morning Skincare"
        static let products = "e.g., Toner, Serum, Moisturizer"
        static let notes = "How did it work? Any observations?"
        static let emptyDiary = "No entries for selected day. Add your first procedure to start your beauty diary!"
        static let emptyNotes = "Here will be your observations about procedures. Add at least one entry in diary."
        static let noNotes = "No notes."
        static let noProducts = "No products listed"
    }
}
