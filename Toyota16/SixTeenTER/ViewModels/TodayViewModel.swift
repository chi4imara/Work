import SwiftUI
import Combine

class TodayViewModel: ObservableObject {
    @Published var todayProgress: DailyProgress
    @Published var tasks: [TaskModel] = []
    @Published var challenges: [TaskModel] = []
    @Published var selectedEnergyLevels: [EnergyType] = []
    @Published var diaryThoughts: String = ""
    @Published var diaryAchievements: String = ""
    @Published var showingAddTask = false
    @Published var showingAddChallenge = false
    
    private let dataManager = DataManager.shared
    
    init() {
        todayProgress = DailyProgress()
        loadTodayData()
    }
    
    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good morning"
        case 12..<17:
            return "Good afternoon"
        default:
            return "Good evening"
        }
    }
    
    var todayTasks: [TaskModel] {
        return tasks.filter { !$0.isCompleted }
    }
    
    var todayChallenges: [TaskModel] {
        return challenges.filter { !$0.isCompleted }
    }
    
    private static let defaultChallengeIds: [UUID] = (0..<5).map { i in
        UUID(uuidString: "00000000-0000-0000-0000-00000000000\(i)") ?? UUID()
    }
    
    var dailyChallenge: TaskModel? {
        let titles = [
            "10 minutes stretching",
            "5 minutes meditation",
            "Write three achievements",
            "Read 10 pages",
            "Drink 8 glasses of water"
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % titles.count
        let id = Self.defaultChallengeIds[index]
        let isCompleted = todayProgress.completedChallenges.contains { $0.id == id }
        return TaskModel(
            id: id,
            title: titles[index],
            type: .challenge,
            priority: .medium,
            frequency: .daily,
            note: "",
            whyImportant: "",
            isCompleted: isCompleted,
            completedDates: isCompleted ? [Date()] : [],
            createdDate: Date(),
            streakDays: 0
        )
    }
    
    func loadTodayData() {
        let today = Calendar.current.startOfDay(for: Date())
        todayProgress = dataManager.getDailyProgress(for: today)
        tasks = dataManager.getTasks().filter { $0.type == .task }
        challenges = dataManager.getTasks().filter { $0.type == .challenge }
        
        if let energyRecord = todayProgress.energyRecord {
            selectedEnergyLevels = energyRecord.energyLevels.map { $0.type }
        }
        
        if let diary = todayProgress.diaryEntry {
            diaryThoughts = diary.thoughts
            diaryAchievements = diary.achievements
        }
    }
    
    func toggleEnergyLevel(_ type: EnergyType) {
        if selectedEnergyLevels.contains(type) {
            selectedEnergyLevels.removeAll { $0 == type }
        } else {
            selectedEnergyLevels.append(type)
        }
        saveEnergyLevels()
    }
    
    private func saveEnergyLevels() {
        if todayProgress.energyRecord == nil {
            todayProgress.energyRecord = DailyEnergyRecord()
        }
        
        todayProgress.energyRecord?.energyLevels.removeAll()
        
        for type in selectedEnergyLevels {
            let energyLevel = EnergyLevel(type: type, level: 4)
            todayProgress.energyRecord?.addEnergyLevel(energyLevel)
        }
        
        dataManager.saveDailyProgress(todayProgress)
    }
    
    func toggleTaskCompletion(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            dataManager.saveTask(tasks[index])
            
            if tasks[index].isCompleted {
                todayProgress.completedTasks.append(tasks[index])
            } else {
                todayProgress.completedTasks.removeAll { $0.id == task.id }
            }
            
            dataManager.saveDailyProgress(todayProgress)
        }
    }
    
    func toggleChallengeCompletion(_ challenge: TaskModel) {
        if let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index].isCompleted.toggle()
            dataManager.saveTask(challenges[index])
            if challenges[index].isCompleted {
                todayProgress.completedChallenges.append(challenges[index])
            } else {
                todayProgress.completedChallenges.removeAll { $0.id == challenge.id }
            }
            dataManager.saveDailyProgress(todayProgress)
        } else if Self.defaultChallengeIds.contains(challenge.id) {
            var newProgress = todayProgress
            if challenge.isCompleted {
                newProgress.completedChallenges.removeAll { $0.id == challenge.id }
            } else {
                var completedChallenge = challenge
                completedChallenge.markCompleted()
                newProgress.completedChallenges.append(completedChallenge)
            }
            todayProgress = newProgress
            dataManager.saveDailyProgress(todayProgress)
        }
    }
    
    func saveDiaryEntry() {
        let diaryEntry = DiaryEntry(thoughts: diaryThoughts, achievements: diaryAchievements)
        todayProgress.diaryEntry = diaryEntry
        dataManager.saveDailyProgress(todayProgress)
    }
    
    func addTask(_ task: TaskModel) {
        tasks.append(task)
        dataManager.saveTask(task)
    }
    
    func addChallenge(_ challenge: TaskModel) {
        challenges.append(challenge)
        dataManager.saveTask(challenge)
    }
}
