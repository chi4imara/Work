import Foundation

struct Activity: Identifiable, Codable {
    let id = UUID()
    var name: String
    var type: ActivityType
    var duration: Int
    var goal: ActivityGoal
    var description: String
    var imageURL: String?
    var isCompleted: Bool = false
    var dateCreated: Date = Date()
}

enum ActivityType: String, CaseIterable, Codable {
    case cinema = "Cinema"
    case reading = "Reading"
    case walk = "Walk"
    case workshop = "Workshop"
    case cooking = "Cooking"
    case fitness = "Fitness"
    case music = "Music"
    case art = "Art"
    
    var icon: String {
        switch self {
        case .cinema: return "tv"
        case .reading: return "book"
        case .walk: return "figure.walk"
        case .workshop: return "hammer"
        case .cooking: return "fork.knife"
        case .fitness: return "figure.yoga"
        case .music: return "music.note"
        case .art: return "paintbrush"
        }
    }
}

enum ActivityGoal: String, CaseIterable, Codable {
    case relaxation = "Relaxation"
    case energyRestore = "Energy Restore"
    case inspiration = "Inspiration"
    case entertainment = "Entertainment"
    case socializing = "Socializing"
    
    var color: String {
        switch self {
        case .relaxation: return "blue"
        case .energyRestore: return "green"
        case .inspiration: return "purple"
        case .entertainment: return "orange"
        case .socializing: return "pink"
        }
    }
}

struct LeisureEvent: Identifiable, Codable {
    let id = UUID()
    var activity: Activity
    var scheduledDate: Date
    var status: EventStatus
    var notes: String = ""
    var rating: Int?
    var photos: [String] = []
}

enum EventStatus: String, CaseIterable, Codable {
    case scheduled = "Scheduled"
    case completed = "Completed"
    case missed = "Missed"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .scheduled: return "blue"
        case .completed: return "green"
        case .missed: return "red"
        case .cancelled: return "gray"
        }
    }
}

struct UserProfile: Codable {
    var name: String = ""
    var email: String = ""
    var avatar: String = ""
    var interests: [ActivityType] = []
    var goals: [ActivityGoal] = []
    var fatigueLevel: FatigueLevel = .medium
    var notificationsEnabled: Bool = true
    var preferredDuration: Int = 60
    
    static let defaultProfile = UserProfile(
        name: "",
        email: "",
        interests: [],
        goals: []
    )
}

enum FatigueLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var description: String {
        switch self {
        case .low: return "Feeling energetic"
        case .medium: return "Moderately tired"
        case .high: return "Very tired"
        }
    }
}

struct ProgressData: Codable {
    var weeklyActivities: [Date: Int] = [:]
    var moodTracking: [Date: MoodLevel] = [:]
    var achievements: [Achievement] = []
    var totalActivitiesCompleted: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
}

enum MoodLevel: String, CaseIterable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case neutral = "Neutral"
    case poor = "Poor"
    case terrible = "Terrible"
    
    var emoji: String {
        switch self {
        case .excellent: return "😄"
        case .good: return "🙂"
        case .neutral: return "😐"
        case .poor: return "🙁"
        case .terrible: return "😢"
        }
    }
    
    var value: Int {
        switch self {
        case .excellent: return 5
        case .good: return 4
        case .neutral: return 3
        case .poor: return 2
        case .terrible: return 1
        }
    }
}

struct Achievement: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var icon: String
    var dateEarned: Date
    var isUnlocked: Bool = false
    
    static let availableAchievements: [Achievement] = [
        Achievement(title: "First Step", description: "Complete your first activity", icon: "star.fill", dateEarned: Date()),
        Achievement(title: "Streak Master", description: "5 days in a row with activities", icon: "flame.fill", dateEarned: Date()),
        Achievement(title: "Explorer", description: "Try 3 different activity types", icon: "map.fill", dateEarned: Date()),
        Achievement(title: "Consistency King", description: "Complete 10 activities", icon: "crown.fill", dateEarned: Date()),
        Achievement(title: "Wellness Warrior", description: "Complete 30 activities", icon: "shield.fill", dateEarned: Date())
    ]
}

enum SampleData {
    static func load() -> (activities: [Activity], events: [LeisureEvent], progressData: ProgressData) {
        let activities: [Activity] = [
            Activity(name: "Morning Walk", type: .walk, duration: 30, goal: .relaxation, description: "A peaceful walk in the park"),
            Activity(name: "Cooking Class", type: .cooking, duration: 90, goal: .inspiration, description: "Learn to make Italian pasta"),
            Activity(name: "Movie Night", type: .cinema, duration: 120, goal: .entertainment, description: "Watch a classic film"),
            Activity(name: "Art Workshop", type: .workshop, duration: 60, goal: .inspiration, description: "Watercolor painting session"),
            Activity(name: "Reading Session", type: .reading, duration: 45, goal: .relaxation, description: "Read your favorite book"),
            Activity(name: "Yoga Class", type: .fitness, duration: 60, goal: .energyRestore, description: "Gentle yoga for beginners")
        ]
        
        let calendar = Calendar.current
        let today = Date()
        let events: [LeisureEvent] = [
            LeisureEvent(
                activity: activities[0],
                scheduledDate: calendar.date(byAdding: .day, value: -2, to: today) ?? today,
                status: .completed,
                notes: "Great morning walk, felt refreshed!",
                rating: 5
            ),
            LeisureEvent(
                activity: activities[1],
                scheduledDate: calendar.date(byAdding: .hour, value: 2, to: today) ?? today,
                status: .scheduled
            ),
            LeisureEvent(
                activity: activities[2],
                scheduledDate: calendar.date(byAdding: .day, value: -5, to: today) ?? today,
                status: .missed
            ),
            LeisureEvent(
                activity: activities[3],
                scheduledDate: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
                status: .completed,
                notes: "Loved the watercolor techniques",
                rating: 4
            ),
            LeisureEvent(
                activity: activities[4],
                scheduledDate: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                status: .scheduled
            )
        ]
        
        var progress = ProgressData()
        progress.totalActivitiesCompleted = 2
        progress.currentStreak = 1
        progress.longestStreak = 3
        let dayStart = calendar.startOfDay(for: today)
        progress.weeklyActivities[dayStart] = 1
        progress.weeklyActivities[calendar.date(byAdding: .day, value: -1, to: dayStart) ?? dayStart] = 1
        progress.moodTracking[dayStart] = .good
        progress.moodTracking[calendar.date(byAdding: .day, value: -1, to: dayStart) ?? dayStart] = .excellent
        if var firstAchievement = Achievement.availableAchievements.first {
            firstAchievement.isUnlocked = true
            firstAchievement.dateEarned = today
            progress.achievements = [firstAchievement]
        }
        
        return (activities, events, progress)
    }
}
