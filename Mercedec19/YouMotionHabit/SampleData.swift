import Foundation

enum SampleData {
    
    static var sampleWorkouts: [Workout] {
        [
            Workout(
                name: "Morning Cardio Blast",
                type: .cardio,
                duration: 30,
                difficulty: .beginner,
                goal: .weightLoss,
                imageName: "figure.run",
                description: "High-energy cardio workout to start your day"
            ),
            Workout(
                name: "Strength Builder",
                type: .strength,
                duration: 45,
                difficulty: .intermediate,
                goal: .strength,
                imageName: "dumbbell",
                description: "Build muscle and increase strength"
            ),
            Workout(
                name: "Peaceful Yoga Flow",
                type: .yoga,
                duration: 60,
                difficulty: .beginner,
                goal: .toning,
                imageName: "figure.yoga",
                description: "Relaxing yoga session for flexibility and peace"
            ),
            Workout(
                name: "Core Pilates",
                type: .pilates,
                duration: 40,
                difficulty: .intermediate,
                goal: .toning,
                imageName: "figure.pilates",
                description: "Strengthen your core with targeted exercises"
            ),
            Workout(
                name: "HIIT Power Session",
                type: .cardio,
                duration: 25,
                difficulty: .advanced,
                goal: .endurance,
                imageName: "bolt.heart",
                description: "High-intensity interval training for maximum results"
            )
        ]
    }
    
    static func sampleScheduledWorkouts(using workouts: [Workout]) -> [ScheduledWorkout] {
        let calendar = Calendar.current
        let today = Date()
        
        guard workouts.count >= 3 else { return [] }
        
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today) ?? today
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) ?? today
        let nextWeek = calendar.date(byAdding: .day, value: 3, to: today) ?? today
        
        return [
            ScheduledWorkout(workout: workouts[0], scheduledDate: twoDaysAgo, status: .completed),
            ScheduledWorkout(workout: workouts[1], scheduledDate: yesterday, status: .completed),
            ScheduledWorkout(workout: workouts[2], scheduledDate: today, status: .planned),
            ScheduledWorkout(workout: workouts[0], scheduledDate: tomorrow, status: .planned),
            ScheduledWorkout(workout: workouts[3], scheduledDate: nextWeek, status: .planned)
        ]
    }
    
    static var sampleProfile: UserProfile {
        var profile = UserProfile()
        profile.name = "Alex Johnson"
        profile.email = "alex.johnson@example.com"
        profile.fitnessLevel = .intermediate
        profile.goals = [.strength, .toning]
        profile.preferredWorkouts = [.cardio, .strength, .yoga]
        profile.notificationsEnabled = true
        profile.avatarImageName = "person.crop.circle.fill"
        return profile
    }
    
    static func sampleProgressData(workouts: [Workout]) -> ProgressData {
        let calendar = Calendar.current
        let today = Date()
        let todayStart = calendar.startOfDay(for: today)
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: today)?.start ?? todayStart
        
        var progress = ProgressData()
        progress.totalWorkouts = 12
        progress.currentStreak = 3
        progress.longestStreak = 5
        
        var weeklyWorkouts: [Date: Int] = [:]
        for dayOffset in 0..<7 {
            if let day = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) {
                let dayStart = calendar.startOfDay(for: day)
                weeklyWorkouts[dayStart] = (dayOffset <= 3 && dayOffset >= 1) ? 2 : (dayOffset == 0 ? 1 : 0)
            }
        }
        progress.weeklyWorkouts = weeklyWorkouts
        
        progress.energyLevels = [todayStart: 4]
        
        var achievements = Achievement.defaultAchievementTemplates()
        if let firstIndex = achievements.firstIndex(where: { $0.title == "First Steps" }) {
            achievements[firstIndex].isUnlocked = true
            achievements[firstIndex].unlockedDate = calendar.date(byAdding: .day, value: -14, to: today)
        }
        progress.achievements = achievements
        
        return progress
    }
    
    static func loadSampleData(
        workoutsVM: WorkoutsViewModel,
        userProfileVM: UserProfileViewModel,
        progressVM: ProgressViewModel
    ) {
        let workouts = sampleWorkouts
        let scheduled = sampleScheduledWorkouts(using: workouts)
        let profile = sampleProfile
        let progressData = sampleProgressData(workouts: workouts)
        
        workoutsVM.loadSampleData(workouts: workouts, scheduled: scheduled)
        userProfileVM.loadSampleData(profile: profile)
        progressVM.loadSampleData(progressData: progressData)
    }
}
