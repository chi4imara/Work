import Foundation

enum SampleData {

    static var habits: [Habit] {
        let calendar = Calendar.current
        let now = Date()

        let habit1CompletedDates = (0..<5).compactMap { calendar.date(byAdding: .day, value: -$0, to: now) }

        let habit2CompletedDates = (1...3).compactMap { calendar.date(byAdding: .day, value: -$0, to: now) }

        let habit3CompletedDates = (0..<2).compactMap { calendar.date(byAdding: .day, value: -$0, to: now) }

        let habit4CompletedDates = (0..<4).compactMap { calendar.date(byAdding: .day, value: -$0, to: now) }

        let habit5Created = calendar.date(byAdding: .day, value: -2, to: now) ?? now

        return [
            Habit(
                id: UUID(),
                title: "Morning walk",
                category: "body",
                icon: "figure.walk",
                frequency: .daily,
                note: "Start the day with fresh air",
                createdDate: calendar.date(byAdding: .day, value: -14, to: now) ?? now,
                completedDates: habit1CompletedDates
            ),
            Habit(
                id: UUID(),
                title: "Read 10 minutes",
                category: "mind",
                icon: "book.fill",
                frequency: .daily,
                note: "Expand my mind every day",
                createdDate: calendar.date(byAdding: .day, value: -10, to: now) ?? now,
                completedDates: habit2CompletedDates
            ),
            Habit(
                id: UUID(),
                title: "Drink 8 glasses of water",
                category: "body",
                icon: "drop.fill",
                frequency: .daily,
                note: "Stay hydrated",
                createdDate: calendar.date(byAdding: .day, value: -7, to: now) ?? now,
                completedDates: habit3CompletedDates
            ),
            Habit(
                id: UUID(),
                title: "Evening meditation",
                category: "mind",
                icon: "leaf.fill",
                frequency: .daily,
                note: "Calm before sleep",
                createdDate: calendar.date(byAdding: .day, value: -5, to: now) ?? now,
                completedDates: habit4CompletedDates
            ),
            Habit(
                id: UUID(),
                title: "Evening journal",
                category: "mind",
                icon: "pencil",
                frequency: .daily,
                note: "Reflect on the day",
                createdDate: habit5Created,
                completedDates: []
            )
        ]
    }

    static func dailyEntries(
        habitIds: [UUID],
        challengeIds: [UUID],
        dailyQuestions: [String]
    ) -> [DailyEntry] {
        let calendar = Calendar.current
        let now = Date()

        let moodOptions = ["happy", "calm", "motivated", "excited", "tired", "stressed"]
        let sampleAnswers = [
            "Spending time outdoors",
            "A good conversation with a friend",
            "Finishing my tasks early",
            "Coffee and a quiet morning",
            "Taking a short nap",
            "Completing my habits",
            "Helping someone today"
        ]

        var entries: [DailyEntry] = []

        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            let startOfDay = calendar.startOfDay(for: date)

            var entry = DailyEntry(date: startOfDay)
            entry.id = UUID()

            let moodCount = dayOffset == 0 ? 2 : (dayOffset % 3 == 0 ? 1 : 2)
            entry.selectedMoods = Array(moodOptions.shuffled().prefix(moodCount))

            let numHabits = min(habitIds.count, 2 + (dayOffset % 3))
            entry.completedHabits = Array(habitIds.prefix(numHabits))

            let numChallenges = min(challengeIds.count, 1 + (dayOffset % 2))
            entry.completedChallenges = Array(challengeIds.prefix(numChallenges))

            let questionIndex = (calendar.ordinality(of: .day, in: .year, for: startOfDay) ?? 1) % dailyQuestions.count
            entry.dailyQuestion = dailyQuestions[questionIndex]
            entry.dailyQuestionAnswer = sampleAnswers[dayOffset % sampleAnswers.count]

            entries.append(entry)
        }

        return entries.sorted { $0.date < $1.date }
    }
}
