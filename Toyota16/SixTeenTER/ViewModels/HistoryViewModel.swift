import SwiftUI
import Combine

class HistoryViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var dailyProgressRecords: [DailyProgress] = []
    @Published var currentMonth: Date = Date()
    
    private let dataManager = DataManager.shared
    private let calendar = Calendar.current
    private var dataChangeObserver: NSObjectProtocol?
    
    init() {
        loadHistoryData()
        dataChangeObserver = NotificationCenter.default.addObserver(
            forName: .dataManagerDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loadHistoryData()
        }
    }
    
    deinit {
        if let o = dataChangeObserver {
            NotificationCenter.default.removeObserver(o)
        }
    }
    
    var selectedDayProgress: DailyProgress? {
        let startOfDay = calendar.startOfDay(for: selectedDate)
        return dailyProgressRecords.first { calendar.isDate($0.date, inSameDayAs: startOfDay) }
    }
    
    var monthDates: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let startOfMonth = monthInterval.start
        let endOfMonth = monthInterval.end
        
        var dates: [Date] = []
        var currentDate = startOfMonth
        
        while currentDate < endOfMonth {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    func loadHistoryData() {
        dailyProgressRecords = dataManager.getAllDailyProgress()
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
    }
    
    func goToPreviousMonth() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentMonth = previousMonth
            }
        }
    }
    
    func goToNextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentMonth = nextMonth
            }
        }
    }
    
    func hasProgressForDate(_ date: Date) -> Bool {
        let startOfDay = calendar.startOfDay(for: date)
        return dailyProgressRecords.contains { calendar.isDate($0.date, inSameDayAs: startOfDay) }
    }
    
    func getProgressForDate(_ date: Date) -> DailyProgress? {
        let startOfDay = calendar.startOfDay(for: date)
        return dailyProgressRecords.first { calendar.isDate($0.date, inSameDayAs: startOfDay) }
    }
    
    func getProgressPercentage(for date: Date) -> Double {
        return getProgressForDate(date)?.progressPercentage ?? 0
    }
    
    func getCompletedTasksCount(for date: Date) -> Int {
        return getProgressForDate(date)?.completedTasks.count ?? 0
    }
    
    func getCompletedChallengesCount(for date: Date) -> Int {
        return getProgressForDate(date)?.completedChallenges.count ?? 0
    }
    
    func getEnergyLevelsCount(for date: Date) -> Int {
        return getProgressForDate(date)?.energyRecord?.energyLevels.count ?? 0
    }
    
    func hasDiaryEntry(for date: Date) -> Bool {
        guard let diary = getProgressForDate(date)?.diaryEntry else { return false }
        return !diary.isEmpty
    }
    
    func getCurrentStreak() -> Int {
        let sortedRecords = dailyProgressRecords
            .filter { $0.progressPercentage > 0 }
            .sorted { $0.date > $1.date }
        
        var streak = 0
        let today = calendar.startOfDay(for: Date())
        
        for record in sortedRecords {
            let recordDate = calendar.startOfDay(for: record.date)
            let daysDifference = calendar.dateComponents([.day], from: recordDate, to: today).day ?? 0
            
            if daysDifference == streak {
                streak += 1
            } else {
                break
            }
        }
        
        return streak
    }
    
    func getTotalCompletedTasks() -> Int {
        return dailyProgressRecords.reduce(0) { $0 + $1.completedTasks.count }
    }
    
    func getTotalCompletedChallenges() -> Int {
        return dailyProgressRecords.reduce(0) { $0 + $1.completedChallenges.count }
    }
}