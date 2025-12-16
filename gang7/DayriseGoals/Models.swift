import Foundation

struct DailyEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let reminder: String
    let intention: String
    let mood: String?
    let gratitude: String?
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

struct Quote: Identifiable, Codable {
    let id = UUID()
    let text: String
    let author: String
}

struct MoodOption: Identifiable {
    let id = UUID()
    let title: String
}

struct AppData {
    static let morningReminders = [
        "Start your day with a deep breath.",
        "Today you don't need to rush.",
        "You can simply be.",
        "It's okay if the morning started slowly.",
        "Sometimes the best plan is just to feel.",
        "Every morning is a chance for kindness.",
        "Today you can be gentle with yourself.",
        "Begin with peace and let it guide you.",
        "This moment is enough.",
        "Trust the rhythm of your heart."
    ]
    
    static let quotes = [
        Quote(text: "Peace is not inaction, but attention to yourself.", author: "Unknown"),
        Quote(text: "A good morning starts with a kind look.", author: "Unknown"),
        Quote(text: "When you wake up with gratitude, the day responds in kind.", author: "Unknown"),
        Quote(text: "The beginning of the day is a place of power, don't rush past it.", author: "Unknown"),
        Quote(text: "The world becomes quieter when you listen to yourself.", author: "Unknown"),
        Quote(text: "Morning is not a time to hurry, but a moment of light's birth.", author: "Unknown"),
        Quote(text: "Stillness is the language of the soul.", author: "Unknown"),
        Quote(text: "Every sunrise is an invitation to brighten someone's day.", author: "Unknown"),
        Quote(text: "In the quiet of morning, wisdom speaks.", author: "Unknown"),
        Quote(text: "Begin each day as if it were on purpose.", author: "Unknown")
    ]
    
    static let moodOptions = [
        MoodOption(title: "Peaceful"),
        MoodOption(title: "Joyful"),
        MoodOption(title: "Sleepy"),
        MoodOption(title: "Fresh"),
        MoodOption(title: "Quiet"),
        MoodOption(title: "Bright"),
        MoodOption(title: "Serious"),
        MoodOption(title: "Gentle")
    ]
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let action: SettingsAction
}

enum SettingsAction {
    case termsAndConditions
    case privacyPolicy
    case contactEmail
    case rateApp
}
