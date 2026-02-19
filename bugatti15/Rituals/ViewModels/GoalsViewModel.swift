import Foundation
import SwiftUI
import Combine

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    @Published var showingAddGoal = false
    @Published var selectedGoal: Goal?
    
    private let dataManager = DataManager.shared
    
    init() {
        loadGoals()
    }
    
    func loadGoals() {
        goals = dataManager.getAllGoals()
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        dataManager.saveGoal(goal)
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        dataManager.deleteGoal(goal.id)
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            dataManager.updateGoal(goal)
        }
    }
    
    func getGoalsByCategory() -> [GoalCategory: [Goal]] {
        return Dictionary(grouping: goals) { $0.category }
    }
    
    func getTodayGoals() -> [Goal] {
        return goals.filter { goal in
            switch goal.frequency {
            case .daily:
                return true
            case .weekly:
                let weekday = Calendar.current.component(.weekday, from: Date())
                return weekday == 2 || weekday == 4 || weekday == 6 
            case .once:
                return !goal.isCompleted
            }
        }
    }
    
    func getCompletedGoalsCount() -> Int {
        return goals.filter { $0.isCompleted }.count
    }
    
    func getTotalGoalsCount() -> Int {
        return goals.count
    }
    
    func getStreakForGoal(_ goal: Goal) -> Int {
        return goal.streak
    }
}
