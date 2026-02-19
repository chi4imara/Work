import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var workouts: [Workout] = []
    @Published var nutritionItems: [Nutrition] = []
    @Published var tasks: [ProductivityTask] = []
    @Published var dailyProgress: [String: DailyProgress] = [:]
    @Published var itemsVersion = UUID()
    
    private let userDefaults = UserDefaults.standard
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadAllData()
        setupAutoSave()
    }
    
    func addWorkout(_ workout: Workout) {
        workouts.append(workout)
        saveWorkouts()
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            var updated = workouts
            updated[index] = workout
            workouts = updated
            itemsVersion = UUID()
            saveWorkouts()
        }
    }
    
    func removeWorkout(withId id: UUID) {
        workouts.removeAll { $0.id == id }
        saveWorkouts()
    }
    
    func getWorkout(withId id: UUID) -> Workout? {
        return workouts.first { $0.id == id }
    }
    
    func addNutrition(_ nutrition: Nutrition) {
        nutritionItems.append(nutrition)
        saveNutrition()
    }
    
    func updateNutrition(_ nutrition: Nutrition) {
        if let index = nutritionItems.firstIndex(where: { $0.id == nutrition.id }) {
            var updated = nutritionItems
            updated[index] = nutrition
            nutritionItems = updated
            itemsVersion = UUID()
            saveNutrition()
        }
    }
    
    func removeNutrition(withId id: UUID) {
        nutritionItems.removeAll { $0.id == id }
        saveNutrition()
    }
    
    func getNutrition(withId id: UUID) -> Nutrition? {
        return nutritionItems.first { $0.id == id }
    }
    
    func addTask(_ task: ProductivityTask) {
        tasks.append(task)
        saveTasks()
    }
    
    func updateTask(_ task: ProductivityTask) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            var updated = tasks
            updated[index] = task
            tasks = updated
            itemsVersion = UUID()
            saveTasks()
        }
    }
    
    func removeTask(withId id: UUID) {
        tasks.removeAll { $0.id == id }
        saveTasks()
    }
    
    func getTask(withId id: UUID) -> ProductivityTask? {
        return tasks.first { $0.id == id }
    }
    
    func updateDailyProgress(_ progress: DailyProgress) {
        let key = dateKey(for: progress.date)
        dailyProgress[key] = progress
        saveDailyProgress()
    }
    
    func getDailyProgress(for date: Date) -> DailyProgress? {
        let key = dateKey(for: date)
        return dailyProgress[key]
    }
    
    private let calendar = Calendar.current
    
    func refreshTodayProgress(challengesCompleted: Int, waterIntake: WaterIntake) {
        let today = Date()
        let key = dateKey(for: today)
        
        let workoutsCompleted = workouts.filter { w in
            guard let d = w.completedDate else { return false }
            return calendar.isDate(d, inSameDayAs: today)
        }.count
        let nutritionItemsCompleted = nutritionItems.filter { n in
            guard let d = n.completedDate else { return false }
            return calendar.isDate(d, inSameDayAs: today)
        }.count
        let tasksCompleted = tasks.filter { t in
            guard let d = t.completedDate else { return false }
            return calendar.isDate(d, inSameDayAs: today)
        }.count
        
        var progress = DailyProgress(date: today)
        progress.workoutsCompleted = workoutsCompleted
        progress.nutritionItemsCompleted = nutritionItemsCompleted
        progress.tasksCompleted = tasksCompleted
        progress.challengesCompleted = challengesCompleted
        progress.waterIntake = waterIntake
        
        dailyProgress[key] = progress
        objectWillChange.send()
        saveDailyProgress()
    }
    
    private func setupAutoSave() {
        $workouts
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveWorkouts()
            }
            .store(in: &cancellables)
        
        $nutritionItems
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveNutrition()
            }
            .store(in: &cancellables)
        
        $tasks
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveTasks()
            }
            .store(in: &cancellables)
        
        $dailyProgress
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveDailyProgress()
            }
            .store(in: &cancellables)
    }
    
    private func loadAllData() {
        loadWorkouts()
        loadNutrition()
        loadTasks()
        loadDailyProgress()
    }
    
    private func loadWorkouts() {
        if let data = userDefaults.data(forKey: "AllWorkouts"),
           let workouts = try? JSONDecoder().decode([Workout].self, from: data) {
            self.workouts = workouts
        }
    }
    
    private func saveWorkouts() {
        if let data = try? JSONEncoder().encode(workouts) {
            userDefaults.set(data, forKey: "AllWorkouts")
        }
    }
    
    private func loadNutrition() {
        if let data = userDefaults.data(forKey: "AllNutrition"),
           let nutrition = try? JSONDecoder().decode([Nutrition].self, from: data) {
            self.nutritionItems = nutrition
        }
    }
    
    private func saveNutrition() {
        if let data = try? JSONEncoder().encode(nutritionItems) {
            userDefaults.set(data, forKey: "AllNutrition")
        }
    }
    
    private func loadTasks() {
        if let data = userDefaults.data(forKey: "AllTasks"),
           let tasks = try? JSONDecoder().decode([ProductivityTask].self, from: data) {
            self.tasks = tasks
        }
    }
    
    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            userDefaults.set(data, forKey: "AllTasks")
        }
    }
    
    private func loadDailyProgress() {
        if let data = userDefaults.data(forKey: "DailyProgress"),
           let progress = try? JSONDecoder().decode([String: DailyProgress].self, from: data) {
            self.dailyProgress = progress
        }
    }
    
    private func saveDailyProgress() {
        if let data = try? JSONEncoder().encode(dailyProgress) {
            userDefaults.set(data, forKey: "DailyProgress")
        }
    }
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func loadSampleData() {
        let cal = Calendar.current
        let today = Date()
        
        var sampleWorkouts: [Workout] = [
            Workout(name: "Morning Run", category: .cardio, duration: 30),
            Workout(name: "Push-ups", category: .strength, duration: 15, repetitions: 20),
            Workout(name: "Yoga Flow", category: .flexibility, duration: 20),
            Workout(name: "HIIT Training", category: .functional, duration: 25, repetitions: 15),
            Workout(name: "Evening Walk", category: .cardio, duration: 45),
        ]
        sampleWorkouts[0].isCompleted = true
        sampleWorkouts[0].completedDate = today
        sampleWorkouts[0].createdDate = cal.date(byAdding: .day, value: 0, to: today) ?? today
        sampleWorkouts[1].isCompleted = true
        sampleWorkouts[1].completedDate = today
        sampleWorkouts[2].isCompleted = false
        sampleWorkouts[2].createdDate = cal.date(byAdding: .day, value: -1, to: today) ?? today
        sampleWorkouts[3].isCompleted = true
        sampleWorkouts[3].completedDate = cal.date(byAdding: .day, value: -2, to: today)
        sampleWorkouts[4].isCompleted = false
        
        workouts = sampleWorkouts
        saveWorkouts()
        
        var sampleNutrition: [Nutrition] = [
            Nutrition(name: "Protein Shake", mealType: .breakfast, calories: 250),
            Nutrition(name: "Grilled Chicken Salad", mealType: .lunch, calories: 400),
            Nutrition(name: "Greek Yogurt", mealType: .snack, calories: 150),
            Nutrition(name: "Salmon with Vegetables", mealType: .dinner, calories: 500),
            Nutrition(name: "Oatmeal", mealType: .breakfast, calories: 300),
        ]
        sampleNutrition[0].isCompleted = true
        sampleNutrition[0].completedDate = today
        sampleNutrition[1].isCompleted = true
        sampleNutrition[1].completedDate = today
        sampleNutrition[2].isCompleted = false
        sampleNutrition[3].isCompleted = true
        sampleNutrition[3].completedDate = cal.date(byAdding: .day, value: -1, to: today)
        
        nutritionItems = sampleNutrition
        saveNutrition()
        
        var sampleTasks: [ProductivityTask] = [
            ProductivityTask(name: "Review project proposal", category: .work, priority: .high),
            ProductivityTask(name: "Read 20 pages", category: .study, priority: .medium),
            ProductivityTask(name: "Call family", category: .personal, priority: .low),
            ProductivityTask(name: "Workout planning", category: .health, priority: .medium),
            ProductivityTask(name: "Send report", category: .work, priority: .high),
        ]
        sampleTasks[0].isCompleted = true
        sampleTasks[0].completedDate = today
        sampleTasks[1].isCompleted = true
        sampleTasks[1].completedDate = today
        sampleTasks[2].isCompleted = false
        sampleTasks[3].isCompleted = true
        sampleTasks[3].completedDate = cal.date(byAdding: .day, value: -3, to: today)
        
        tasks = sampleTasks
        saveTasks()
        
        var water = WaterIntake()
        water.currentAmount = 1200
        water.targetAmount = 2000
        water.date = today
        
        for dayOffset in 0...5 {
            guard let date = cal.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            let key = dateKey(for: date)
            var progress = DailyProgress(date: date)
            progress.workoutsCompleted = dayOffset == 0 ? 2 : (dayOffset <= 2 ? 1 : 0)
            progress.nutritionItemsCompleted = dayOffset == 0 ? 2 : (dayOffset <= 1 ? 1 : 0)
            progress.tasksCompleted = dayOffset == 0 ? 2 : (dayOffset == 3 ? 1 : 0)
            progress.challengesCompleted = dayOffset <= 1 ? 1 : 0
            progress.waterIntake = dayOffset == 0 ? water : WaterIntake()
            dailyProgress[key] = progress
        }
        saveDailyProgress()
        
        itemsVersion = UUID()
        objectWillChange.send()
    }
}
