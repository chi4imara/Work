import Foundation
import Combine

class StatisticsViewModel: ObservableObject {
    private let dataManager = TasksDataManager.shared
    
    @Published var totalTasks: Int = 0
    @Published var lastAddedDate: Date?
    @Published var categoryDistribution: [TaskCategory: Int] = [:]
    @Published var timelineData: [TimelineData] = []
    @Published var selectedPeriod: TimePeriod = .week
    
    enum TimePeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    struct TimelineData: Identifiable {
        let id = UUID()
        let date: Date
        let count: Int
    }
    
    init() {
        updateStatistics()
    }
    
    func updateStatistics() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.fetchTotalTasks()
            self.fetchLastAddedDate()
            self.fetchCategoryDistribution()
            self.fetchTimelineData()
        }
    }
    
    private func fetchTotalTasks() {
        let tasks = dataManager.loadTasks()
        totalTasks = tasks.count
    }
    
    private func fetchLastAddedDate() {
        let tasks = dataManager.loadTasks().sorted { $0.dateCreated > $1.dateCreated }
        lastAddedDate = tasks.first?.dateCreated
    }
    
    private func fetchCategoryDistribution() {
        categoryDistribution.removeAll()
        let tasks = dataManager.loadTasks()
        
        for category in TaskCategory.allCases {
            let count = tasks.filter { $0.category == category.rawValue }.count
            if count > 0 {
                categoryDistribution[category] = count
            }
        }
    }
    
    private func fetchTimelineData() {
        let calendar = Calendar.current
        let now = Date()
        var startDate: Date
        var dateComponents: Calendar.Component
        
        switch selectedPeriod {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            dateComponents = .day
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            dateComponents = .day
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            dateComponents = .month
        }
        
        let tasks = dataManager.loadTasks().filter { $0.dateCreated >= startDate }
        timelineData = processTimelineData(tasks: tasks, startDate: startDate, component: dateComponents)
    }
    
    private func processTimelineData(tasks: [PartyTask], startDate: Date, component: Calendar.Component) -> [TimelineData] {
        let calendar = Calendar.current
        var data: [Date: Int] = [:]
        
        for task in tasks {
            let dateKey = calendar.dateInterval(of: component, for: task.dateCreated)?.start ?? task.dateCreated
            data[dateKey, default: 0] += 1
        }
        
        return data.map { TimelineData(date: $0.key, count: $0.value) }
            .sorted { $0.date < $1.date }
    }
    
    func updatePeriod(_ period: TimePeriod) {
        selectedPeriod = period
        fetchTimelineData()
    }
}
