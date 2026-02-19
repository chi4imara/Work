import Foundation

enum SampleData {
    
    private static let habitId1 = UUID()
    private static let habitId2 = UUID()
    private static let habitId3 = UUID()
    private static let habitId4 = UUID()
    private static let habitId5 = UUID()
    
    static func makeSampleHabits() -> [Habit] {
        let calendar = Calendar.current
        let today = Date()
        
        func habit(_ id: UUID, name: String, category: HabitCategory, icon: String, completedDaysAgo: [Int]) -> Habit {
            var h = Habit(name: name, category: category, frequency: .daily, icon: icon, whyImportant: "Sample: helps with energy")
            h.id = id
            h.createdDate = calendar.date(byAdding: .day, value: -30, to: today) ?? today
            h.completedDates = completedDaysAgo.compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
            return h
        }
        
        return [
            habit(habitId1, name: "Morning Affirmation", category: .morningRituals, icon: "heart.fill", completedDaysAgo: [0, 1, 2, 3, 4, 5, 6, 7]),
            habit(habitId2, name: "Gratitude Journal", category: .achievementDiary, icon: "book.fill", completedDaysAgo: [0, 1, 2, 4, 6, 8, 10]),
            habit(habitId3, name: "Deep Breathing", category: .breathing, icon: "lungs.fill", completedDaysAgo: [0, 1, 3, 5, 7]),
            habit(habitId4, name: "Evening Reflection", category: .achievementDiary, icon: "moon.fill", completedDaysAgo: [0, 2, 4]),
            habit(habitId5, name: "Weekly Goal Review", category: .miniChallenge, icon: "target", completedDaysAgo: [7, 14])
        ]
    }
    
    static func makeSampleDailyEntries(habitIds: [UUID]) -> [DailyEntry] {
        let calendar = Calendar.current
        let today = Date()
        var entries: [DailyEntry] = []
        
        for dayOffset in 0..<14 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            var entry = DailyEntry(date: date)
            
            switch dayOffset {
            case 0:
                entry.energyLevels = [.good, .high]
                entry.completedRitual = true
                entry.completedChallenge = true
                entry.completedHabits = Array(habitIds.prefix(3))
                entry.notes = "Great day!"
            case 1:
                entry.energyLevels = [.high]
                entry.completedRitual = true
                entry.completedChallenge = true
                entry.completedHabits = habitIds
            case 2:
                entry.energyLevels = [.medium, .good]
                entry.completedRitual = false
                entry.completedChallenge = true
                entry.completedHabits = Array(habitIds.prefix(2))
            case 3:
                entry.energyLevels = [.excellent]
                entry.completedRitual = true
                entry.completedChallenge = true
                entry.completedHabits = Array(habitIds.prefix(4))
                entry.notes = "Very productive"
            case 4:
                entry.energyLevels = [.low, .medium]
                entry.completedRitual = true
                entry.completedChallenge = false
                entry.completedHabits = [habitIds[0]]
            case 5, 6:
                entry.energyLevels = [.good]
                entry.completedRitual = true
                entry.completedChallenge = true
                entry.completedHabits = Array(habitIds.prefix(3))
            case 7...9:
                entry.energyLevels = [.medium]
                entry.completedRitual = dayOffset % 2 == 0
                entry.completedChallenge = true
                entry.completedHabits = Array(habitIds.prefix(2))
            default:
                entry.energyLevels = [.good, .high]
                entry.completedRitual = true
                entry.completedChallenge = true
                entry.completedHabits = Array(habitIds.prefix(2))
            }
            
            entries.append(entry)
        }
        
        return entries
    }
    
    static func makeSampleTodayEntry(habitIds: [UUID]) -> DailyEntry {
        var entry = DailyEntry(date: Date())
        entry.energyLevels = [.good, .high]
        entry.completedRitual = true
        entry.completedChallenge = true
        entry.completedHabits = Array(habitIds.prefix(3))
        entry.notes = "Sample data loaded"
        return entry
    }
}
