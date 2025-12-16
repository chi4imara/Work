import Foundation

struct Constants {

    struct App {
        static let name = "Memory Helper"
        static let version = "1.0.0"
        static let tagline = "One day — one memory"
    }
    
    struct UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let diaryEntries = "diary_entries"
    }
    
    struct Limits {
        static let maxEntryLength = 200
        static let maxPreviewLines = 3
    }
    
    struct URLs {
        static let termsAndConditions = "https://www.google.com"
        static let privacyPolicy = "https://www.google.com"
        static let contactUs = "https://www.google.com"
    }
    
    struct Onboarding {
        static let title1 = "Remember One Thing Each Day"
        static let description1 = "This app helps you keep one small memory from every day. Each evening, you'll see a simple question — 'What will you remember today?' — and you can write a short note, just a few words or a sentence."
        
        static let title2 = "Build Your Memory Archive"
        static let description2 = "Over time, these moments form your quiet archive of days — ordinary details, warm moments, small thoughts. You don't have to write perfectly — just capture something true about your day."
        
        static let title3 = "One Line a Day"
        static let description3 = "One line a day, one memory at a time. Start your journey of mindful remembering today."
    }
    
    struct Questions {
        static let dailyQuestion = "What will you remember today?"
        static let dailySubtitle = "You can write one sentence. The essence matters, not the length."
        static let placeholder = "Write a moment, thought, feeling..."
        static let tip = "Don't try to write perfectly. The main thing is that it's yours."
    }
    
    struct WritingTips {
        static let howToStart = "Write the first thing that comes to mind. It can be a moment, smell, word, or feeling."
        static let whatToRemember = "A phrase, glance, rain, taste, place, meeting, sound, smile."
        static let whyWrite = "Each entry is a small anchor. It holds the day when everything else is forgotten."
        static let example = "Today: conversation at the bus stop, smell of coffee and a short \"thank you\"."
    }
    
    struct Messages {
        static let entrySaved = "Remembered"
        static let changesSaved = "Changes saved"
        static let entryDeleted = "Entry deleted"
        static let allEntriesDeleted = "All entries deleted"
    }
    
    struct EmptyStates {
        static let noEntries = "You don't have any memories yet. Start today."
        static let noSearchResults = "No memories found"
        static let searchTip = "Try adjusting your search or date filter"
        static let firstEntry = "Every day — a new memory. Start with today's."
    }
}
