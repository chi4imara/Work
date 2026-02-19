import Foundation

enum SampleData {
    
    static func loadSampleData(into userDefaults: UserDefaults = .standard) {
        let calendar = Calendar.current
        
        var morningWalk = Habit(
            name: "Morning walk",
            category: .body,
            icon: "figure.walk",
            frequency: .daily,
            whyImportant: "Start the day with fresh air and movement"
        )
        var meditation = Habit(
            name: "Meditation",
            category: .soul,
            icon: "leaf.fill",
            frequency: .daily,
            whyImportant: "Calm the mind and reduce stress"
        )
        var breathing = Habit(
            name: "Breathing practice",
            category: .soul,
            icon: "wind",
            frequency: .daily
        )
        var reading = Habit(
            name: "Reading",
            category: .hobby,
            icon: "book.fill",
            frequency: .daily,
            whyImportant: "Learn something new every day"
        )
        var journaling = Habit(
            name: "Journaling",
            category: .soul,
            icon: "pencil",
            frequency: .weekly,
            whyImportant: "Reflect on the day"
        )
        
        let today = Date()
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            morningWalk.completedDates.append(date)
            meditation.completedDates.append(date)
            if dayOffset < 5 {
                breathing.completedDates.append(date)
            }
            if dayOffset % 2 == 0 {
                reading.completedDates.append(date)
            }
            if dayOffset == 0 || dayOffset == 2 || dayOffset == 4 {
                journaling.completedDates.append(date)
            }
        }
        
        let habits = [morningWalk, meditation, breathing, reading, journaling]
        
        if let data = try? JSONEncoder().encode(habits) {
            userDefaults.set(data, forKey: "habits")
        }
        
        let habitIds = habits.map(\.id)
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            
            let moodsForDay: [(String, String)] = [
                ("😊", "Happy"),
                ("🤗", "Grateful"),
                ("😌", "Calm")
            ]
            let selectedMoods = moodsForDay.prefix(2).map { emoji, name in
                Mood(emoji: emoji, name: name, date: dayStart)
            }
            
            let gratitudeTexts = [
                "Family and health",
                "A peaceful morning",
                "Progress on my goals",
                "Good weather",
                "A kind message from a friend"
            ]
            let gratitudeEntries = gratitudeTexts.prefix(dayOffset % 3 + 1).map {
                GratitudeEntry(text: $0, date: dayStart)
            }
            
            let question = DailyQuestion.questions[dayOffset % DailyQuestion.questions.count]
            let answer = "Sample answer for day \(-dayOffset)."
            let dailyQuestion = DailyQuestion(question: question, answer: answer, date: dayStart)
            
            let completedCount = dayOffset == 0 ? 2 : min(habitIds.count, 1 + dayOffset % 3)
            let completedHabits = Array(habitIds.prefix(completedCount))
            
            var entry = DailyEntry(date: dayStart)
            entry.selectedMoods = selectedMoods
            entry.gratitudeEntries = gratitudeEntries
            entry.dailyQuestion = dailyQuestion
            entry.completedHabits = completedHabits
            
            let key = "dailyEntry_\(dayStart.timeIntervalSince1970)"
            if let data = try? JSONEncoder().encode(entry) {
                userDefaults.set(data, forKey: key)
            }
        }
    }
}
