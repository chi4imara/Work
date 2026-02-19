import Foundation
import SwiftUI

enum SampleData {
    private static let calendar = Calendar.current
    
    static func makeSampleRituals() -> [Ritual] {
        let today = calendar.startOfDay(for: Date())
        var rituals: [Ritual] = [
            Ritual(title: "Morning Meditation", category: .mindfulness, description: "5 minutes of mindful breathing"),
            Ritual(title: "Gratitude Journal", category: .journaling, description: "Write 3 things you're grateful for"),
            Ritual(title: "Evening Walk", category: .physical, description: "Take a peaceful walk outside"),
            Ritual(title: "Deep Breathing", category: .mindfulness, description: "Practice deep breathing exercises"),
            Ritual(title: "Creative Time", category: .creative, frequency: .weekly, description: "Draw or write for 15 minutes")
        ]
        
        for (index, _) in rituals.enumerated() {
            var ritual = rituals[index]
            ritual.completionDates = (0..<min(5 + index, 7)).compactMap { dayOffset in
                calendar.date(byAdding: .day, value: -dayOffset, to: today)
            }
            rituals[index] = ritual
        }
        
        return rituals
    }
    
    static func makeSampleEntries(ritualIds: [UUID], today: Date) -> [DailyEntry] {
        let moods = Mood.allMoods
        var entries: [DailyEntry] = []
        
        for dayOffset in 0..<10 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            
            let moodIndex = dayOffset % moods.count
            let mood = moods[moodIndex]
            
            var entry = DailyEntry(date: startOfDay, mood: mood, note: sampleNotes[dayOffset % sampleNotes.count])
            
            let ritualsToComplete = min(2 + (dayOffset % 2), ritualIds.count)
            entry.completedRituals = Set(ritualIds.prefix(ritualsToComplete))
            
            let dayIndex = calendar.ordinality(of: .day, in: .year, for: date) ?? 0
            let challengeIndex = dayIndex % Challenge.dailyChallenges.count
            let challengeId = Challenge.dailyChallenges[challengeIndex].id
            if dayOffset % 2 == 0 {
                entry.completedChallenges = [challengeId]
            }
            
            entry.gratitudes = dayOffset < 3 ? ["Family", "Health", "Nature"] : []
            
            entries.append(entry)
        }
        
        return entries
    }
    
    private static let sampleNotes: [String] = [
        "Feeling good today, had a productive morning.",
        "A bit tired but grateful for the small things.",
        "Calm and focused. Meditation helped.",
        "Busy day ahead. Taking it one step at a time.",
        "Wonderful walk in the park.",
        "Reflecting on the week.",
        "Staying present.",
        "Small wins matter.",
        "Rest day. Self-care is important.",
        "Ready for a new week."
    ]
}
