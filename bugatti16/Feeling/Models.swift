import Foundation
import SwiftUI
import Combine

struct Mood: Identifiable, Codable {
    let id = UUID()
    let emotion: EmotionType
    let note: String
    let date: Date
    let photoData: Data?
    
    enum EmotionType: String, CaseIterable, Codable {
        case happy = "happy"
        case tired = "tired"
        case inspired = "inspired"
        case anxious = "anxious"
        case sad = "sad"
        case calm = "calm"
        case excited = "excited"
        case peaceful = "peaceful"
        
        var displayName: String {
            switch self {
            case .happy: return "Happy"
            case .tired: return "Tired"
            case .inspired: return "Inspired"
            case .anxious: return "Anxious"
            case .sad: return "Sad"
            case .calm: return "Calm"
            case .excited: return "Excited"
            case .peaceful: return "Peaceful"
            }
        }
        
        var color: Color {
            switch self {
            case .happy: return .appPrimaryYellow
            case .tired: return .appTextSecondary
            case .inspired: return .appLavender
            case .anxious: return .appSoftPink
            case .sad: return .appPrimaryBlue.opacity(0.7)
            case .calm: return .appLightGreen
            case .excited: return .appPeach
            case .peaceful: return .appPrimaryBlue.opacity(0.5)
            }
        }
        
        var systemImage: String {
            switch self {
            case .happy: return "face.smiling"
            case .tired: return "powersleep"
            case .inspired: return "lightbulb"
            case .anxious: return "heart.fill"
            case .sad: return "cloud.rain"
            case .calm: return "leaf"
            case .excited: return "star.fill"
            case .peaceful: return "moon"
            }
        }
    }
    
    static var allMoods: [Mood] {
        EmotionType.allCases.map { Mood(emotion: $0, note: "", date: Date(), photoData: nil) }
    }
}

struct Ritual: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: RitualCategory
    var frequency: Frequency
    var description: String
    var isCompleted: Bool = false
    var completionDates: [Date] = []
    var streak: Int = 0
    let createdDate: Date
    
    enum RitualCategory: String, CaseIterable, Codable {
        case meditation = "meditation"
        case breathing = "breathing"
        case gratitude = "gratitude"
        case exercise = "exercise"
        case reading = "reading"
        case journaling = "journaling"
        case selfCare = "self_care"
        case mindfulness = "mindfulness"
        
        var displayName: String {
            switch self {
            case .meditation: return "Meditation"
            case .breathing: return "Breathing"
            case .gratitude: return "Gratitude"
            case .exercise: return "Exercise"
            case .reading: return "Reading"
            case .journaling: return "Journaling"
            case .selfCare: return "Self Care"
            case .mindfulness: return "Mindfulness"
            }
        }
        
        var color: Color {
            switch self {
            case .meditation: return .appLavender
            case .breathing: return .appPrimaryBlue
            case .gratitude: return .appPrimaryYellow
            case .exercise: return .appPeach
            case .reading: return .appLightGreen
            case .journaling: return .appSoftPink
            case .selfCare: return .appPrimaryYellow.opacity(0.8)
            case .mindfulness: return .appPrimaryBlue.opacity(0.7)
            }
        }
        
        var systemImage: String {
            switch self {
            case .meditation: return "figure.mind.and.body"
            case .breathing: return "lungs"
            case .gratitude: return "heart.fill"
            case .exercise: return "figure.run"
            case .reading: return "book"
            case .journaling: return "pencil"
            case .selfCare: return "sparkles"
            case .mindfulness: return "brain.head.profile"
            }
        }
    }
    
    enum Frequency: String, CaseIterable, Codable {
        case daily = "daily"
        case weekly = "weekly"
        case oneTime = "one_time"
        
        var displayName: String {
            switch self {
            case .daily: return "Daily"
            case .weekly: return "Weekly"
            case .oneTime: return "One Time"
            }
        }
    }
}

struct DailyEntry: Identifiable, Codable {
    var id: UUID
    var date: Date
    var selectedMood: Mood?
    var note: String = ""
    var completedRituals: [UUID] = []
    var completedChallenge: DailyChallenge?
    var progressPercentage: Double = 0.0
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
    }
}

struct UserProgress: Codable {
    var totalDays: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var completedRituals: Int = 0
    var completedChallenges: Int = 0
}

struct DailyChallenge: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var category: Ritual.RitualCategory
    var isCompleted: Bool = false
    var date: Date = Date()
    
    static let challenges: [DailyChallenge] = [
        DailyChallenge(title: "5-Minute Meditation", description: "Take 5 minutes to focus on your breath", category: .meditation),
        DailyChallenge(title: "Gratitude List", description: "Write down 3 things you're grateful for", category: .gratitude),
        DailyChallenge(title: "Deep Breathing", description: "Practice 4-7-8 breathing technique", category: .breathing),
        DailyChallenge(title: "Mindful Walk", description: "Take a 10-minute walk in nature", category: .exercise),
        DailyChallenge(title: "Self-Reflection", description: "Journal about your feelings today", category: .journaling),
        DailyChallenge(title: "Self-Care Moment", description: "Do something nice for yourself", category: .selfCare)
    ]
}

struct Challenge: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var completionDate: Date?
    let createdDate: Date
    
    static let dailyChallenges = [
        "Take 5 deep breaths mindfully",
        "Write down 3 things you're grateful for",
        "Spend 10 minutes in nature",
        "Call someone you care about",
        "Do a 5-minute meditation",
        "Write a positive affirmation",
        "Take a mindful walk",
        "Practice self-compassion",
        "Listen to calming music",
        "Stretch for 10 minutes"
    ]
}

struct DailyProgress: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var mood: Mood?
    var completedRituals: [UUID] = []
    var completedChallenge: Challenge?
    var progressPercentage: Double {
        var completed = 0.0
        let total = 3.0
        
        if mood != nil { completed += 1 }
        if !completedRituals.isEmpty { completed += 1 }
        if completedChallenge?.isCompleted == true { completed += 1 }
        
        return completed / total
    }
}

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding = false
    @Published var currentMood: Mood?
    @Published var rituals: [Ritual] = []
    @Published var dailyProgress: [DailyProgress] = []
    @Published var todayChallenge: Challenge?
    
    init() {
        loadSampleData()
        generateTodayChallenge()
    }
    
    private func loadSampleData() {
        rituals = [
            Ritual(name: "Morning Meditation", category: .meditation, frequency: .daily, description: "5 minutes of mindful breathing", createdDate: Date()),
            Ritual(name: "Gratitude Journal", category: .gratitude, frequency: .daily, description: "Write 3 things I'm grateful for", createdDate: Date()),
            Ritual(name: "Evening Stretch", category: .exercise, frequency: .daily, description: "10 minutes of gentle stretching", createdDate: Date())
        ]
    }
    
    func generateTodayChallenge() {
        let randomChallenge = Challenge.dailyChallenges.randomElement() ?? "Take a moment to breathe deeply"
        todayChallenge = Challenge(
            title: "Today's Mini Challenge",
            description: randomChallenge,
            createdDate: Date()
        )
    }
    
    func completeChallenge() {
        todayChallenge?.isCompleted = true
        todayChallenge?.completionDate = Date()
    }
    
    func addMood(_ mood: Mood) {
        currentMood = mood
        updateTodayProgress()
    }
    
    func completeRitual(_ ritual: Ritual) {
        if let index = rituals.firstIndex(where: { $0.id == ritual.id }) {
            rituals[index].isCompleted = true
            rituals[index].completionDates.append(Date())
            rituals[index].streak += 1
            updateTodayProgress()
        }
    }
    
    private func updateTodayProgress() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index].mood = currentMood
            dailyProgress[index].completedRituals = rituals.filter { $0.isCompleted }.map { $0.id }
            dailyProgress[index].completedChallenge = todayChallenge
        } else {
            let newProgress = DailyProgress(
                date: today,
                mood: currentMood,
                completedRituals: rituals.filter { $0.isCompleted }.map { $0.id },
                completedChallenge: todayChallenge
            )
            dailyProgress.append(newProgress)
        }
    }
    
    func getTodayProgress() -> DailyProgress? {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyProgress.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
}
