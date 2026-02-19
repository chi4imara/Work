import Foundation

enum SampleData {
    
    static func makePractices() -> [Practice] {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
        
        return [
            Practice(
                name: "Morning Stretch",
                type: .movement,
                duration: 5,
                streak: 7,
                lastCompleted: yesterday,
                note: "Helps wake up the body and improve flexibility"
            ),
            Practice(
                name: "Deep Breathing",
                type: .breathing,
                duration: 3,
                streak: 3,
                lastCompleted: twoDaysAgo,
                note: "Calms the nervous system"
            ),
            Practice(
                name: "Evening Relaxation",
                type: .recovery,
                duration: 10,
                streak: 2,
                lastCompleted: yesterday,
                note: "Release tension before sleep"
            ),
            Practice(
                name: "Rest Break",
                type: .rest,
                duration: 5,
                streak: 0,
                lastCompleted: nil,
                note: "Short pause during the day"
            )
        ]
    }
    
    static func makeHistoryEntries(calendar: Calendar) -> [HistoryEntry] {
        let today = calendar.startOfDay(for: Date())
        var entries: [HistoryEntry] = []
        
        for dayOffset in (0..<14).reversed() {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            let isToday = calendar.isDate(date, inSameDayAs: today)
            let hasData = dayOffset < 7 || isToday
            
            var wellnessStates: [WellnessType: Int] = [:]
            var completedPractices: [String] = []
            var completedChallenges: [String] = []
            
            if hasData {
                wellnessStates[.energy] = (2...4).randomElement() ?? 3
                wellnessStates[.tension] = (1...4).randomElement() ?? 2
                wellnessStates[.fatigue] = (1...5).randomElement() ?? 3
                
                if dayOffset <= 3 || isToday {
                    completedPractices = ["Morning Stretch", "Deep Breathing"]
                    if dayOffset <= 1 || isToday {
                        completedChallenges = ["Stand and Stretch", "Screen Break"]
                    }
                } else if dayOffset <= 5 {
                    completedPractices = ["Morning Stretch"]
                    completedChallenges = ["Stand and Stretch"]
                }
            }
            
            var careLevel: Double = 0
            if !wellnessStates.isEmpty { careLevel += 0.3 }
            if !completedPractices.isEmpty { careLevel += 0.4 }
            if !completedChallenges.isEmpty { careLevel += 0.3 }
            careLevel = min(careLevel, 1.0)
            
            let entry = HistoryEntry(
                date: date,
                wellnessStates: wellnessStates,
                completedPractices: completedPractices,
                completedChallenges: completedChallenges,
                careLevel: careLevel
            )
            entries.append(entry)
        }
        
        return entries.reversed()
    }
}
