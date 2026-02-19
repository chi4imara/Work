import Foundation

enum SampleData {
    
    static func makeTodayProgress() -> DailyProgress {
        let calendar = Calendar.current
        let today = Date()
        var progress = DailyProgress(date: today)
        
        let bedtime = calendar.date(byAdding: .hour, value: -8, to: today) ?? today
        progress.sleepEntry = SleepEntry(bedtime: bedtime, wakeTime: today, quality: 4)
        
        progress.mealEntries = [
            MealEntry(type: .breakfast, name: "Oatmeal with berries", healthRating: 5),
            MealEntry(type: .lunch, name: "Salad with chicken", healthRating: 4),
            MealEntry(type: .dinner, name: "Grilled fish and vegetables", healthRating: 5)
        ]
        
        progress.activityEntries = [
            ActivityEntry(type: .walk, name: "Morning walk", duration: 1800),
            ActivityEntry(type: .yoga, name: "Evening yoga", duration: 900)
        ]
        progress.activityEntries[0].isCompleted = true
        progress.activityEntries[1].isCompleted = true
        
        let challenge = Challenge.sampleChallenges[0]
        progress.completedChallenges = [challenge.id]
        
        progress.moodRating = 4
        progress.energyLevel = 4
        progress.notes = "Good day overall."
        
        return progress
    }
    
    static func makeDailyChallenge() -> Challenge {
        var challenge = Challenge.sampleChallenges[0]
        challenge.isCompleted = true
        return challenge
    }
    
    static func makeHabits() -> [Habit] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var habits = [
            Habit(name: "Morning meditation", category: .mindfulness, icon: "brain.head.profile"),
            Habit(name: "Drink 8 glasses of water", category: .nutrition, icon: "drop"),
            Habit(name: "30 min walk", category: .activity, icon: "figure.walk"),
            Habit(name: "Read before bed", category: .selfCare, icon: "book"),
            Habit(name: "Sleep 8 hours", category: .sleep, icon: "bed.double"),
            Habit(name: "No phone 1 hour before sleep", category: .selfCare, icon: "moon"),
            Habit(name: "10 min stretching", category: .activity, icon: "figure.flexibility")
        ]
        
        for i in 0..<habits.count {
            var completedDates: [Date] = []
            for dayOffset in 0..<min(7 + i, 14) {
                if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                    completedDates.append(calendar.startOfDay(for: date))
                }
            }
            habits[i].completedDates = completedDates
        }
        
        return habits
    }
    
    static func makeFullHistory() -> [DailyProgress] {
        let calendar = Calendar.current
        let todayProgress = makeTodayProgress()
        var history: [DailyProgress] = [todayProgress]
        
        for dayOffset in 1..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            var progress = DailyProgress(date: startOfDay)
            
            let hasSleep = dayOffset % 3 != 0
            let hasMeals = dayOffset % 4 != 0
            let hasActivity = dayOffset % 2 == 0
            
            if hasSleep {
                progress.sleepEntry = SleepEntry(
                    bedtime: calendar.date(byAdding: .hour, value: -8, to: startOfDay) ?? startOfDay,
                    wakeTime: startOfDay,
                    quality: [3, 4, 5].randomElement()!
                )
            }
            if hasMeals {
                progress.mealEntries = [
                    MealEntry(type: .breakfast, name: "Breakfast", healthRating: [3, 4, 5].randomElement()!),
                    MealEntry(type: .lunch, name: "Lunch", healthRating: [3, 4, 5].randomElement()!)
                ]
            }
            if hasActivity {
                let act = ActivityEntry(type: .walk, name: "Walk", duration: [900, 1800, 2700].randomElement()!)
                progress.activityEntries = [act]
            }
            if dayOffset % 2 == 0 {
                progress.completedChallenges = [Challenge.sampleChallenges[0].id]
            }
            progress.moodRating = [3, 4, 5].randomElement()!
            progress.energyLevel = [3, 4, 5].randomElement()!
            
            history.append(progress)
        }
        
        return history
    }
}
