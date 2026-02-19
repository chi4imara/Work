import SwiftUI
import StoreKit
import Combine

class AppState: ObservableObject {
    private enum Keys {
        static let isFirstLaunch = "isFirstLaunch"
        static let workouts = "userDefaults_workouts"
        static let meals = "userDefaults_meals"
        static let goals = "userDefaults_goals"
        static let dailyChallenges = "userDefaults_dailyChallenges"
        static let progress = "userDefaults_progress"
        static let waterIntake = "userDefaults_waterIntake"
        static let targetWaterIntake = "userDefaults_targetWaterIntake"
    }
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    @Published var isFirstLaunch = true
    @Published var workouts: [Workout] = []
    @Published var meals: [Meal] = []
    @Published var goals: [Goal] = []
    @Published var dailyChallenges: [Challenge] = []
    @Published var progress: [DayProgress] = []
    @Published var selectedTab = 0
    @Published var waterIntake: Int = 0
    @Published var targetWaterIntake: Int = 8
    
    init() {
        loadData()
        generateDailyChallenge()
    }
        
    func loadData() {
        isFirstLaunch = !defaults.bool(forKey: Keys.isFirstLaunch)
        
        if let data = defaults.data(forKey: Keys.workouts),
           let decoded = try? decoder.decode([Workout].self, from: data) {
            workouts = decoded
        } else {
            workouts = []
        }
        
        if let data = defaults.data(forKey: Keys.meals),
           let decoded = try? decoder.decode([Meal].self, from: data) {
            meals = decoded
        } else {
            meals = []
        }
        
        if let data = defaults.data(forKey: Keys.goals),
           let decoded = try? decoder.decode([Goal].self, from: data) {
            goals = decoded
        } else {
            goals = []
        }
        
        if let data = defaults.data(forKey: Keys.dailyChallenges),
           let decoded = try? decoder.decode([Challenge].self, from: data) {
            dailyChallenges = decoded
        }
        
        if let data = defaults.data(forKey: Keys.progress),
           let decoded = try? decoder.decode([DayProgress].self, from: data) {
            progress = decoded
        }
        
        waterIntake = defaults.integer(forKey: Keys.waterIntake)
        if defaults.object(forKey: Keys.targetWaterIntake) != nil {
            targetWaterIntake = defaults.integer(forKey: Keys.targetWaterIntake)
        }
    }
    
    func saveData() {
        defaults.set(true, forKey: Keys.isFirstLaunch)
        
        if let data = try? encoder.encode(workouts) {
            defaults.set(data, forKey: Keys.workouts)
        }
        if let data = try? encoder.encode(meals) {
            defaults.set(data, forKey: Keys.meals)
        }
        if let data = try? encoder.encode(goals) {
            defaults.set(data, forKey: Keys.goals)
        }
        if let data = try? encoder.encode(dailyChallenges) {
            defaults.set(data, forKey: Keys.dailyChallenges)
        }
        if let data = try? encoder.encode(progress) {
            defaults.set(data, forKey: Keys.progress)
        }
        
        defaults.set(waterIntake, forKey: Keys.waterIntake)
        defaults.set(targetWaterIntake, forKey: Keys.targetWaterIntake)
    }
    
    func completeOnboarding() {
        isFirstLaunch = false
        saveData()
    }
        
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        saveData()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
            saveData()
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
        saveData()
    }
    
    func toggleWorkoutCompletion(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].isCompleted.toggle()
            updateDayProgress()
            saveData()
        }
    }
    
    func addMeal(_ meal: Meal) {
        meals.append(meal)
        saveData()
    }
    
    func updateMeal(_ meal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index] = meal
            saveData()
        }
    }
    
    func deleteMeal(_ meal: Meal) {
        meals.removeAll { $0.id == meal.id }
        saveData()
    }
    
    func toggleMealCompletion(_ meal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index].isCompleted.toggle()
            updateDayProgress()
            saveData()
        }
    }
        
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveData()
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveData()
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        saveData()
    }
        
    func generateDailyChallenge() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if !dailyChallenges.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            let challenges = [
                Challenge(title: "10,000 Steps", description: "Walk 10,000 steps today", targetValue: 10000),
                Challenge(title: "5 Minutes Plank", description: "Hold plank for 5 minutes total", targetValue: 300),
                Challenge(title: "Drink 8 Glasses", description: "Drink 8 glasses of water", targetValue: 8),
                Challenge(title: "30 Push-ups", description: "Do 30 push-ups today", targetValue: 30),
                Challenge(title: "Meditation", description: "Meditate for 10 minutes", targetValue: 10)
            ]
            
            let randomChallenge = challenges.randomElement()!
            var newChallenge = randomChallenge
            newChallenge.date = today
            
            dailyChallenges.append(newChallenge)
        }
    }
    
    func updateChallengeProgress(_ challenge: Challenge, value: Int) {
        if let index = dailyChallenges.firstIndex(where: { $0.id == challenge.id }) {
            var updated = dailyChallenges[index]
            updated.currentValue = min(value, challenge.targetValue)
            updated.isCompleted = updated.currentValue >= challenge.targetValue
            dailyChallenges[index] = updated
            updateDayProgress()
            saveData()
        }
    }
    
    func completeDailyChallenge() {
        let today = Calendar.current.startOfDay(for: Date())
        if let index = dailyChallenges.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            var updated = dailyChallenges[index]
            updated.isCompleted = true
            updated.currentValue = updated.targetValue
            dailyChallenges[index] = updated
            updateDayProgress()
            saveData()
        }
    }
        
    func updateDayProgress() {
        let today = Calendar.current.startOfDay(for: Date())
        
        let todayWorkouts = workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        let todayMeals = meals.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        let todayChallenge = dailyChallenges.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
        
        let workoutsCompleted = todayWorkouts.filter { $0.isCompleted }.count
        let mealsCompleted = todayMeals.filter { $0.isCompleted }.count
        let goalsProgress = goals.isEmpty ? 0 : goals.map { $0.currentValue / $0.targetValue }.reduce(0, +) / Double(goals.count)
        let challengeCompleted = todayChallenge?.isCompleted ?? false
        
        if let index = progress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            var dayProgress = progress[index]
            dayProgress.workoutsCompleted = workoutsCompleted
            dayProgress.mealsCompleted = mealsCompleted
            dayProgress.goalsProgress = goalsProgress
            dayProgress.challengeCompleted = challengeCompleted
            progress[index] = dayProgress
        } else {
            let dayProgress = DayProgress(
                date: today,
                workoutsCompleted: workoutsCompleted,
                mealsCompleted: mealsCompleted,
                goalsProgress: goalsProgress,
                challengeCompleted: challengeCompleted
            )
            progress.append(dayProgress)
        }
    }
        
    func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        case 17..<22:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
    
    func getTodayProgress() -> DayProgress? {
        let today = Calendar.current.startOfDay(for: Date())
        return progress.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    func workout(byId id: UUID) -> Workout? {
        workouts.first { $0.id == id }
    }
    
    func meal(byId id: UUID) -> Meal? {
        meals.first { $0.id == id }
    }
    
    func goal(byId id: UUID) -> Goal? {
        goals.first { $0.id == id }
    }
    
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func loadSampleData() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        
        let workoutTemplates: [(String, WorkoutCategory, Int, Bool)] = [
            ("Morning Run", .cardio, 35, true),
            ("Upper Body", .strength, 45, true),
            ("HIIT Session", .functional, 25, true),
            ("Leg Day", .strength, 50, false),
            ("Yoga Flow", .functional, 40, true),
            ("Cycling", .cardio, 30, true),
            ("Push Day", .strength, 55, true)
        ]
        workouts = (0..<7).compactMap { dayOffset -> Workout? in
            guard let date = cal.date(byAdding: .day, value: -dayOffset, to: today) else { return nil }
            let t = workoutTemplates[dayOffset % workoutTemplates.count]
            return Workout(
                name: t.0,
                category: t.1,
                duration: t.2,
                exercises: [
                    Exercise(name: "Set 1", sets: 3, reps: 10, weight: 20),
                    Exercise(name: "Set 2", sets: 3, reps: 8, weight: 22.5)
                ],
                isCompleted: t.3,
                date: date,
                isFavorite: dayOffset % 3 == 0,
                notes: ""
            )
        }
        
        let mealTemplates: [(String, MealType, Int, Double, Double, Double, Bool)] = [
            ("Oatmeal with berries", .breakfast, 320, 12, 52, 8, true),
            ("Chicken salad", .lunch, 450, 35, 28, 18, true),
            ("Salmon & rice", .dinner, 580, 38, 55, 22, true),
            ("Protein shake", .snack, 120, 24, 4, 2, true),
            ("Scrambled eggs", .breakfast, 280, 18, 4, 22, true),
            ("Turkey wrap", .lunch, 420, 28, 42, 14, true),
            ("Pasta with vegetables", .dinner, 520, 16, 72, 18, true),
            ("Greek yogurt", .snack, 150, 12, 18, 4, true)
        ]
        var allMeals: [Meal] = []
        for dayOffset in 0..<7 {
            guard let dayStart = cal.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let count = 2 + (dayOffset % 3)
            for i in 0..<count {
                let t = mealTemplates[(dayOffset + i) % mealTemplates.count]
                allMeals.append(Meal(
                    name: t.0,
                    mealType: t.1,
                    calories: t.2,
                    protein: t.3,
                    carbs: t.4,
                    fat: t.5,
                    isCompleted: t.6,
                    date: dayStart,
                    notes: ""
                ))
            }
        }
        meals = allMeals
        
        let futureDate1 = cal.date(byAdding: .day, value: 30, to: today) ?? today
        let futureDate2 = cal.date(byAdding: .day, value: 14, to: today) ?? today
        let futureDate3 = cal.date(byAdding: .day, value: 60, to: today) ?? today
        goals = [
            Goal(title: "Lose 5 kg", description: "Target weight loss", targetValue: 5, currentValue: 2.5, unit: "kg", category: .weightLoss, deadline: futureDate1, isFavorite: true),
            Goal(title: "Run 50 km", description: "Monthly running goal", targetValue: 50, currentValue: 32, unit: "km", category: .endurance, deadline: futureDate2),
            Goal(title: "Bench 80 kg", description: "Strength target", targetValue: 80, currentValue: 72, unit: "kg", category: .strength, deadline: futureDate3, isFavorite: true)
        ]
        
        let challengeTitles = [
            ("10,000 Steps", "Walk 10,000 steps", 10000),
            ("8 Glasses of Water", "Drink 8 glasses", 8),
            ("30 Push-ups", "Do 30 push-ups", 30),
            ("5 Min Plank", "Hold plank 5 min", 300),
            ("Meditation 10 min", "Meditate 10 minutes", 10)
        ]
        dailyChallenges = (0..<7).compactMap { dayOffset -> Challenge? in
            guard let date = cal.date(byAdding: .day, value: -dayOffset, to: today) else { return nil }
            let c = challengeTitles[dayOffset % challengeTitles.count]
            var ch = Challenge(title: c.0, description: c.1, targetValue: c.2, date: date)
            ch.currentValue = dayOffset <= 2 ? c.2 : (dayOffset == 3 ? c.2 / 2 : 0)
            ch.isCompleted = dayOffset <= 2
            return ch
        }
        if !dailyChallenges.contains(where: { cal.isDate($0.date, inSameDayAs: today) }) {
            generateDailyChallenge()
        }
        
        progress = (0..<7).compactMap { dayOffset -> DayProgress? in
            guard let date = cal.date(byAdding: .day, value: -dayOffset, to: today) else { return nil }
            let workoutsDone = dayOffset <= 4 ? 1 : 0
            let mealsDone = min(3, 2 + dayOffset % 2)
            let challengeDone = dayOffset <= 2
            let goalProg = 0.4 + Double(dayOffset) * 0.08
            return DayProgress(
                date: date,
                workoutsCompleted: workoutsDone,
                mealsCompleted: mealsDone,
                goalsProgress: min(goalProg, 1.0),
                challengeCompleted: challengeDone
            )
        }
        
        waterIntake = 5
        targetWaterIntake = 8
        saveData()
    }
}
