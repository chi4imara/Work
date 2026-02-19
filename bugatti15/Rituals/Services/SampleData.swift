import Foundation

enum SampleData {
    
    static func makeSampleGoals() -> [Goal] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let walkId = UUID()
        let walkCompletions = (1...3).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
        let walk = Goal(
            id: walkId,
            title: "Morning walk",
            category: .body,
            frequency: .daily,
            icon: "figure.walk",
            description: "Take a refreshing morning walk",
            isCompleted: false,
            completionDates: walkCompletions,
            createdDate: calendar.date(byAdding: .day, value: -14, to: today)!,
            streak: 3
        )
        
        let meditationId = UUID()
        let meditationCompletions = [today, calendar.date(byAdding: .day, value: -1, to: today)!]
        let meditation = Goal(
            id: meditationId,
            title: "Mini meditation",
            category: .soul,
            frequency: .daily,
            icon: "heart.fill",
            description: "5 minutes of mindfulness",
            isCompleted: true,
            completionDates: meditationCompletions,
            createdDate: calendar.date(byAdding: .day, value: -14, to: today)!,
            streak: 2
        )
        
        let readId = UUID()
        let read = Goal(
            id: readId,
            title: "Read a book",
            category: .hobby,
            frequency: .daily,
            icon: "book.fill",
            description: "Read at least 10 pages",
            isCompleted: false,
            completionDates: [],
            createdDate: calendar.date(byAdding: .day, value: -7, to: today)!,
            streak: 0
        )
        
        let coffeeId = UUID()
        let coffee = Goal(
            id: coffeeId,
            title: "Coffee with a friend",
            category: .social,
            frequency: .weekly,
            icon: "person.2.fill",
            description: "Enjoy quality time with friends",
            isCompleted: false,
            completionDates: [],
            createdDate: calendar.date(byAdding: .day, value: -14, to: today)!,
            streak: 0
        )
        
        let journalId = UUID()
        let journalCompletions = (0...4).compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
        let journal = Goal(
            id: journalId,
            title: "Gratitude journal",
            category: .soul,
            frequency: .daily,
            icon: "pencil",
            description: "Write 3 things you're grateful for",
            isCompleted: false,
            completionDates: journalCompletions,
            createdDate: calendar.date(byAdding: .day, value: -14, to: today)!,
            streak: 5
        )
        
        let stretchId = UUID()
        let stretch = Goal(
            id: stretchId,
            title: "Evening stretching",
            category: .body,
            frequency: .daily,
            icon: "leaf.fill",
            description: "10 min stretch before bed",
            isCompleted: false,
            completionDates: [],
            createdDate: calendar.date(byAdding: .day, value: -3, to: today)!,
            streak: 0
        )
        
        return [walk, meditation, read, coffee, journal, stretch]
    }
    
    static func makeSampleEntries(goalIds: [UUID]) -> [DailyEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let questions = DailyQuestions.questions
        let moodTypes = MoodType.allCases
        
        var entries: [DailyEntry] = []
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            var entry = DailyEntry(date: date)
            
            let moodCount = Int.random(in: 1...2)
            let shuffledMoods = moodTypes.shuffled()
            for i in 0..<min(moodCount, shuffledMoods.count) {
                let mood = Mood(type: shuffledMoods[i], intensity: Int.random(in: 2...5), date: date)
                entry.addMood(mood)
            }
            
            let completedCount = min(goalIds.count, Int.random(in: 2...4))
            for i in 0..<completedCount {
                entry.completeGoal(goalIds[i])
            }
            entry.updateProgress(totalGoals: goalIds.count)
            
            let questionIndex = dayOffset % questions.count
            let question = questions[questionIndex]
            let answers = [
                "Spending time outdoors and reading.",
                "A quiet morning with coffee.",
                "Finishing my tasks and calling my sister.",
                "Yoga and a good book.",
                "Meeting a friend for lunch.",
                "Completing my mini-goals and feeling accomplished.",
                "Taking time to rest and reflect."
            ]
            entry.setDailyQuestion(question, answer: answers[dayOffset % answers.count])
            
            entries.append(entry)
        }
        
        return entries.sorted { $0.date > $1.date }
    }
    
    static func makeSampleData() -> (goals: [Goal], entries: [DailyEntry]) {
        let goals = makeSampleGoals()
        let goalIds = goals.map(\.id)
        let entries = makeSampleEntries(goalIds: goalIds)
        return (goals, entries)
    }
}
