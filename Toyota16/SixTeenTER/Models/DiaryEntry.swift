import Foundation

struct DiaryEntry: Identifiable, Codable {
    let id: UUID
    var thoughts: String
    var achievements: String
    let date: Date
    
    init(thoughts: String = "", achievements: String = "", date: Date = Date()) {
        self.id = UUID()
        self.thoughts = thoughts
        self.achievements = achievements
        self.date = date
    }
    
    var isEmpty: Bool {
        return thoughts.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               achievements.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct DailyProgress: Identifiable, Codable {
    let id: UUID
    let date: Date
    var energyRecord: DailyEnergyRecord?
    var completedTasks: [TaskModel]
    var completedChallenges: [TaskModel]
    var diaryEntry: DiaryEntry?
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
        self.energyRecord = nil
        self.completedTasks = []
        self.completedChallenges = []
        self.diaryEntry = nil
    }
    
    var progressPercentage: Double {
        var completedItems = 0
        var totalItems = 0
        
        if energyRecord != nil && !energyRecord!.energyLevels.isEmpty {
            completedItems += 1
        }
        totalItems += 1
        
        if !completedTasks.isEmpty {
            completedItems += 1
        }
        totalItems += 1
        
        if !completedChallenges.isEmpty {
            completedItems += 1
        }
        totalItems += 1
        
        if let diary = diaryEntry, !diary.isEmpty {
            completedItems += 1
        }
        totalItems += 1
        
        return totalItems > 0 ? Double(completedItems) / Double(totalItems) : 0
    }
    
    var isFullyCompleted: Bool {
        return progressPercentage >= 1.0
    }
}
