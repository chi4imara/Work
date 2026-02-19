import Foundation
import SwiftUI
import Combine

class SkinCareViewModel: ObservableObject {
    @Published var procedures: [Procedure] = []
    @Published var skinEntries: [SkinEntry] = []
    @Published var dailyProgress: [DailyProgress] = []
    @Published var hasCompletedOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let proceduresKey = "SavedProcedures"
    private let skinEntriesKey = "SavedSkinEntries"
    private let dailyProgressKey = "SavedDailyProgress"
    private let onboardingKey = "HasCompletedOnboarding"
    
    init() {
        loadData()
    }
    
    func loadData() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        
        if let proceduresData = userDefaults.data(forKey: proceduresKey),
           let decodedProcedures = try? JSONDecoder().decode([Procedure].self, from: proceduresData) {
            procedures = decodedProcedures
        }
        
        if let skinEntriesData = userDefaults.data(forKey: skinEntriesKey),
           let decodedSkinEntries = try? JSONDecoder().decode([SkinEntry].self, from: skinEntriesData) {
            skinEntries = decodedSkinEntries
        }
        
        if let dailyProgressData = userDefaults.data(forKey: dailyProgressKey),
           let decodedDailyProgress = try? JSONDecoder().decode([DailyProgress].self, from: dailyProgressData) {
            dailyProgress = decodedDailyProgress
        }
    }
    
    func saveData() {
        if let proceduresData = try? JSONEncoder().encode(procedures) {
            userDefaults.set(proceduresData, forKey: proceduresKey)
        }
        
        if let skinEntriesData = try? JSONEncoder().encode(skinEntries) {
            userDefaults.set(skinEntriesData, forKey: skinEntriesKey)
        }
        
        if let dailyProgressData = try? JSONEncoder().encode(dailyProgress) {
            userDefaults.set(dailyProgressData, forKey: dailyProgressKey)
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func addProcedure(_ procedure: Procedure) {
        procedures.append(procedure)
        updateTodayProgress()
        saveData()
    }
    
    func updateProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index] = procedure
            saveData()
        }
    }
    
    func deleteProcedure(_ procedure: Procedure) {
        deleteProcedure(byId: procedure.id)
    }
    
    func toggleProcedureCompletion(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index].isCompleted.toggle()
            
            if procedures[index].isCompleted {
                procedures[index].markAsCompleted()
                addCompletedProcedureToToday(procedure.id)
            } else {
                removeCompletedProcedureFromToday(procedure.id)
            }
            
            saveData()
        }
    }
    
    func addSkinEntry(_ entry: SkinEntry) {
        skinEntries.append(entry)
        addSkinEntryToToday(entry)
        saveData()
    }
    
    func getTodayProgress() -> DailyProgress {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let todayProgress = dailyProgress.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            return todayProgress
        }
        
        let newProgress = DailyProgress(date: today, totalProcedures: getDailyProcedures().count)
        dailyProgress.append(newProgress)
        saveData()
        return newProgress
    }
    
    func updateTodayProgress() {
        let today = Calendar.current.startOfDay(for: Date())
        let dailyProceduresCount = getDailyProcedures().count
        
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index].totalProcedures = dailyProceduresCount
        } else {
            let newProgress = DailyProgress(date: today, totalProcedures: dailyProceduresCount)
            dailyProgress.append(newProgress)
        }
        
        saveData()
    }
    
    private func addCompletedProcedureToToday(_ procedureId: UUID) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index].addCompletedProcedure(procedureId)
        }
    }
    
    private func removeCompletedProcedureFromToday(_ procedureId: UUID) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index].removeCompletedProcedure(procedureId)
        }
    }
    
    private func addSkinEntryToToday(_ entry: SkinEntry) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index].addSkinEntry(entry)
        }
    }
    
    func getDailyProcedures() -> [Procedure] {
        return procedures.filter { $0.type == .daily }
    }
    
    func getWeeklyProcedures() -> [Procedure] {
        return procedures.filter { $0.type == .weekly }
    }
    
    func getTodayCompletionPercentage() -> Double {
        let todayProgress = getTodayProgress()
        return todayProgress.completionPercentage
    }
    
    func getProgressForDate(_ date: Date) -> DailyProgress? {
        let targetDate = Calendar.current.startOfDay(for: date)
        return dailyProgress.first { Calendar.current.isDate($0.date, inSameDayAs: targetDate) }
    }
    
    func getSkinEntriesForDate(_ date: Date) -> [SkinEntry] {
        return skinEntries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func procedure(byId id: UUID) -> Procedure? {
        procedures.first { $0.id == id }
    }
    
    func deleteProcedure(byId id: UUID) {
        procedures.removeAll { $0.id == id }
        removeProcedureIdFromAllProgress(procedureId: id)
        updateTodayProgress()
        saveData()
    }
    
    private func removeProcedureIdFromAllProgress(procedureId: UUID) {
        for i in dailyProgress.indices {
            dailyProgress[i].removeCompletedProcedure(procedureId)
        }
    }
    
    func weeklyCompletionStats() -> (completed: Int, total: Int) {
        let calendar = Calendar.current
        let now = Date()
        guard let weekStart = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) else { return (0, 0) }
        var completed = 0
        var total = 0
        for dayOffset in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else { continue }
            if let progress = getProgressForDate(day) {
                completed += progress.completedProcedures.count
                total += progress.totalProcedures
            }
        }
        return (completed, total)
    }
    
    struct DayStat {
        let day: Date
        let shortDayName: String
        let percentage: Double
    }
    
    func lastSevenDaysStats() -> [DayStat] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        var result: [DayStat] = []
        for offset in (0..<7).reversed() {
            guard let day = calendar.date(byAdding: .day, value: -offset, to: calendar.startOfDay(for: Date())) else { continue }
            let progress = getProgressForDate(day)
            let pct = progress?.completionPercentage ?? 0
            result.append(DayStat(
                day: day,
                shortDayName: formatter.string(from: day),
                percentage: pct
            ))
        }
        return result
    }
    
    func skinConditionCounts() -> [String: Int] {
        var counts: [String: Int] = [:]
        for entry in skinEntries {
            counts[entry.condition.rawValue, default: 0] += 1
        }
        return counts
    }
    
    func loadSampleData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var cleanser = Procedure(name: "Cleanser", type: .daily, frequency: .twiceDaily, timeOfDay: .morning, duration: 2, notes: "Gentle foam")
        var toner = Procedure(name: "Toner", type: .daily, frequency: .twiceDaily, timeOfDay: .morning, duration: 1)
        var moisturizer = Procedure(name: "Moisturizer", type: .daily, frequency: .onceDaily, timeOfDay: .evening, duration: 2)
        var spf = Procedure(name: "SPF", type: .daily, frequency: .onceDaily, timeOfDay: .morning, duration: 1, notes: "Minimum SPF 30")
        
        var faceMask = Procedure(name: "Face Mask", type: .weekly, frequency: .twiceWeekly, timeOfDay: .evening, duration: 15)
        var peeling = Procedure(name: "Peeling", type: .weekly, frequency: .onceWeekly, timeOfDay: .evening, duration: 5)
        var faceMassage = Procedure(name: "Face Massage", type: .weekly, frequency: .threeTimesWeekly, timeOfDay: .anytime, duration: 10)
        
        let dailyIds = [cleanser.id, toner.id, moisturizer.id, spf.id]
        
        for dayOffset in 0..<5 {
            guard let day = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            if dayOffset == 0 {
                cleanser.completedDates.append(day)
                toner.completedDates.append(day)
                moisturizer.completedDates.append(day)
                spf.completedDates.append(day)
                cleanser.isCompleted = true
                toner.isCompleted = true
                moisturizer.isCompleted = true
                spf.isCompleted = true
            } else if dayOffset == 1 {
                cleanser.completedDates.append(day)
                toner.completedDates.append(day)
                moisturizer.completedDates.append(day)
            } else if dayOffset == 2 {
                cleanser.completedDates.append(day)
                toner.completedDates.append(day)
            }
        }
        
        procedures = [cleanser, toner, moisturizer, spf, faceMask, peeling, faceMassage]
        
        let conditions: [SkinEntry.SkinCondition] = [.normal, .improved, .normal, .dry, .normal, .improved, .normal]
        let notesSamples = ["Skin feels balanced", "Routine is working", "", "Slightly dry after mask", "Good hydration", "Visible improvement", "Consistent care"]
        skinEntries = (0..<7).compactMap { offset -> SkinEntry? in
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today),
                  let hour = calendar.date(byAdding: .hour, value: 9, to: date) else { return nil }
            return SkinEntry(condition: conditions[offset], notes: notesSamples[offset], date: hour)
        }
        
        dailyProgress = (0..<7).compactMap { offset -> DailyProgress? in
            guard let day = calendar.date(byAdding: .day, value: -offset, to: today) else { return nil }
            let totalDaily = 4
            var completedIds: [UUID] = []
            switch offset {
            case 0: completedIds = dailyIds
            case 1: completedIds = Array(dailyIds.prefix(3))
            case 2: completedIds = Array(dailyIds.prefix(2))
            case 3: completedIds = dailyIds
            case 4: completedIds = Array(dailyIds.prefix(1))
            default: break
            }
            let daySkinEntries = skinEntries.filter { calendar.isDate($0.date, inSameDayAs: day) }
            var progress = DailyProgress(date: day, totalProcedures: totalDaily)
            progress.completedProcedures = completedIds
            progress.skinEntries = daySkinEntries
            return progress
        }
        
        saveData()
    }
}
