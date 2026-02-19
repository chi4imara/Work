import Foundation

enum SampleData {
    
    static func generate(challengeId: UUID) -> (habits: [Habit], dailyProgress: [DailyProgress]) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let habit1Id = UUID()
        let habit2Id = UUID()
        let habit3Id = UUID()
        
        var habit1Dates: [Date] = []
        var habit2Dates: [Date] = []
        var habit3Dates: [Date] = []
        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            habit1Dates.append(date)
            if dayOffset % 2 == 0 { habit2Dates.append(date) }
            if dayOffset < 4 { habit3Dates.append(date) }
        }
        
        let habits: [Habit] = [
            Habit(
                id: habit1Id,
                name: "Morning meditation",
                category: .meditation,
                iconName: "leaf.fill",
                frequency: .daily,
                whyImportant: "Start the day with clarity",
                createdDate: calendar.date(byAdding: .day, value: -14, to: today)!,
                completedDates: habit1Dates,
                isActive: true
            ),
            Habit(
                id: habit2Id,
                name: "Deep breathing",
                category: .breathing,
                iconName: "wind",
                frequency: .daily,
                whyImportant: "Calm the nervous system",
                createdDate: calendar.date(byAdding: .day, value: -10, to: today)!,
                completedDates: habit2Dates,
                isActive: true
            ),
            Habit(
                id: habit3Id,
                name: "Gratitude journal",
                category: .emotionalJournal,
                iconName: "book.fill",
                frequency: .weekly,
                whyImportant: "Focus on the positive",
                createdDate: calendar.date(byAdding: .day, value: -7, to: today)!,
                completedDates: habit3Dates,
                isActive: true
            )
        ]
        
        let moodHappy = Mood(emoji: "😊", name: "Happy", date: today)
        let moodCalm = Mood(emoji: "😌", name: "Calm", date: today)
        let moodTired = Mood(emoji: "😴", name: "Tired", date: today)
        
        var dailyProgress: [DailyProgress] = []
        for dayOffset in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
            let isToday = dayOffset == 0
            
            let moodsForDay: [Mood] = isToday ? [moodHappy, moodCalm] : (dayOffset % 2 == 0 ? [moodHappy] : [moodCalm, moodTired])
            let completedHabitsForDay: [UUID] = isToday
                ? [habit1Id, habit2Id]
                : (dayOffset % 2 == 0 ? [habit1Id, habit2Id] : [habit1Id])
            let completedChallengesForDay: [UUID] = (dayOffset <= 2) ? [challengeId] : []
            let meditationDone = dayOffset <= 3
            
            dailyProgress.append(DailyProgress(
                date: date,
                selectedMoods: moodsForDay,
                completedHabits: completedHabitsForDay,
                completedChallenges: completedChallengesForDay,
                meditationCompleted: meditationDone
            ))
        }
        
        return (habits, dailyProgress)
    }
}
