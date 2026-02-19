import Foundation
import SwiftUI
import Combine

private enum StorageKey {
    static let procedures = "grooming_procedures"
    static let healthMetrics = "grooming_healthMetrics"
    static let dailyProgress = "grooming_dailyProgress"
    static let currentChallenge = "grooming_currentChallenge"
    static let hasCompletedOnboarding = "grooming_hasCompletedOnboarding"
}

class GroomingViewModel: ObservableObject {
    @Published var procedures: [Procedure] = []
    @Published var healthMetrics: [HealthMetric] = HealthMetric.defaultMetrics
    @Published var dailyProgress: [DailyProgress] = []
    @Published var currentChallenge: Challenge
    @Published var hasCompletedOnboarding = false
    
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        self.currentChallenge = Challenge.dailyChallenges.randomElement() ?? Challenge.dailyChallenges[0]
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        if let data = defaults.data(forKey: StorageKey.procedures),
           let decoded = try? decoder.decode([Procedure].self, from: data) {
            procedures = decoded
        }
        if let data = defaults.data(forKey: StorageKey.healthMetrics),
           let decoded = try? decoder.decode([HealthMetric].self, from: data) {
            healthMetrics = decoded
        }
        if let data = defaults.data(forKey: StorageKey.dailyProgress),
           let decoded = try? decoder.decode([DailyProgress].self, from: data) {
            dailyProgress = decoded
        }
        if let data = defaults.data(forKey: StorageKey.currentChallenge),
           let decoded = try? decoder.decode(Challenge.self, from: data) {
            currentChallenge = decoded
        }
        hasCompletedOnboarding = defaults.bool(forKey: StorageKey.hasCompletedOnboarding)
    }
    
    func saveToUserDefaults() {
        if let data = try? encoder.encode(procedures) {
            defaults.set(data, forKey: StorageKey.procedures)
        }
        if let data = try? encoder.encode(healthMetrics) {
            defaults.set(data, forKey: StorageKey.healthMetrics)
        }
        if let data = try? encoder.encode(dailyProgress) {
            defaults.set(data, forKey: StorageKey.dailyProgress)
        }
        if let data = try? encoder.encode(currentChallenge) {
            defaults.set(data, forKey: StorageKey.currentChallenge)
        }
        defaults.set(hasCompletedOnboarding, forKey: StorageKey.hasCompletedOnboarding)
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        saveToUserDefaults()
    }
    
    func procedure(byId id: UUID) -> Procedure? {
        procedures.first { $0.id == id }
    }
    
    func addProcedure(_ procedure: Procedure) {
        procedures.append(procedure)
        saveToUserDefaults()
    }
    
    func updateProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index] = procedure
            saveToUserDefaults()
        }
    }
    
    func deleteProcedure(_ procedure: Procedure) {
        procedures.removeAll { $0.id == procedure.id }
        saveToUserDefaults()
    }
    
    func deleteProcedure(byId id: UUID) {
        procedures.removeAll { $0.id == id }
        saveToUserDefaults()
    }
    
    func toggleProcedureCompletion(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index].isCompleted.toggle()
            if procedures[index].isCompleted {
                procedures[index].completionDates.append(Date())
            }
            updateTodayProgress()
            saveToUserDefaults()
        }
    }
    
    func toggleProcedureFavorite(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index].isFavorite.toggle()
            saveToUserDefaults()
        }
    }
    
    func updateHealthMetric(_ metric: HealthMetric) {
        if let index = healthMetrics.firstIndex(where: { $0.id == metric.id }) {
            healthMetrics[index] = metric
            updateTodayProgress()
            saveToUserDefaults()
        }
    }
    
    func completeChallenge() {
        currentChallenge.isCompleted = true
        currentChallenge.completionDate = Date()
        updateTodayProgress()
        saveToUserDefaults()
    }
    
    func getNewChallenge() {
        currentChallenge = Challenge.dailyChallenges.randomElement() ?? Challenge.dailyChallenges[0]
        saveToUserDefaults()
    }
    
    private static let careCategories: Set<Procedure.ProcedureCategory> = [.skincare, .beard, .hair, .nails]
    
    private func updateTodayProgress() {
        let today = Calendar.current.startOfDay(for: Date())
        let completed = procedures.filter { $0.isCompleted }
        let careBlockDone = completed.contains { Self.careCategories.contains($0.category) }
        let styleBlockDone = completed.contains { $0.category == .style }
        let procedureIds = completed.map { $0.id }
        let metrics = healthMetrics.filter { !$0.value.isEmpty }
        let challenge = currentChallenge.isCompleted ? currentChallenge : nil
        let newProgress = DailyProgress(
            date: today,
            completedProcedures: procedureIds,
            healthMetrics: metrics,
            completedChallenge: challenge,
            careBlockDone: careBlockDone,
            styleBlockDone: styleBlockDone
        )
        
        if let index = dailyProgress.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            dailyProgress[index] = newProgress
        } else {
            dailyProgress.append(newProgress)
        }
        objectWillChange.send()
        saveToUserDefaults()
    }
    
    func getTodayProgress() -> DailyProgress? {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyProgress.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
    
    func getProgressForDate(_ date: Date) -> DailyProgress? {
        let targetDate = Calendar.current.startOfDay(for: date)
        return dailyProgress.first { Calendar.current.isDate($0.date, inSameDayAs: targetDate) }
    }
    
    func getGreeting() -> String {
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
    
    func loadSampleData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        procedures = [
            Procedure(name: "Morning Skincare", category: .skincare, frequency: "Daily", notes: "Cleanser, moisturizer, sunscreen"),
            Procedure(name: "Beard Trim", category: .beard, frequency: "Weekly", notes: "Use beard trimmer"),
            Procedure(name: "Hair Wash", category: .hair, frequency: "Every 2 days", notes: "Use quality shampoo"),
            Procedure(name: "Nail Care", category: .nails, frequency: "Weekly", notes: "Trim and clean nails"),
            Procedure(name: "Haircut Reminder", category: .style, frequency: "Monthly", notes: "Book next appointment"),
            Procedure(name: "Evening Skincare", category: .skincare, frequency: "Daily", notes: "Cleanser, serum, moisturizer")
        ]
        
        if let skincareIdx = procedures.firstIndex(where: { $0.name == "Morning Skincare" }) {
            procedures[skincareIdx].isCompleted = true
            procedures[skincareIdx].completionDates = [today, calendar.date(byAdding: .day, value: -1, to: today)!]
            procedures[skincareIdx].isFavorite = true
        }
        if let beardIdx = procedures.firstIndex(where: { $0.name == "Beard Trim" }) {
            procedures[beardIdx].isCompleted = true
            procedures[beardIdx].completionDates = [today]
        }
        if let styleIdx = procedures.firstIndex(where: { $0.name == "Haircut Reminder" }) {
            procedures[styleIdx].isFavorite = true
        }
        
        healthMetrics = [
            HealthMetric(name: "Weight", value: "72", unit: "kg", date: today),
            HealthMetric(name: "Pulse", value: "65", unit: "bpm", date: today),
            HealthMetric(name: "Steps", value: "8500", unit: "steps", date: today),
            HealthMetric(name: "Water", value: "2", unit: "L", date: today)
        ]
        
        currentChallenge = Challenge.dailyChallenges[0]
        currentChallenge.isCompleted = true
        currentChallenge.completionDate = today
        
        let completedIds = procedures.filter { $0.isCompleted }.map { $0.id }
        let careDone = procedures.contains { Self.careCategories.contains($0.category) && $0.isCompleted }
        let styleDone = procedures.contains { $0.category == .style && $0.isCompleted }
        dailyProgress = [
            DailyProgress(
                date: today,
                completedProcedures: completedIds,
                healthMetrics: healthMetrics,
                completedChallenge: currentChallenge,
                careBlockDone: careDone,
                styleBlockDone: styleDone
            )
        ]
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today) {
            dailyProgress.append(DailyProgress(
                date: yesterday,
                completedProcedures: Array(completedIds.prefix(2)),
                healthMetrics: Array(healthMetrics.dropLast()),
                completedChallenge: nil,
                careBlockDone: true,
                styleBlockDone: false
            ))
        }
        
        saveToUserDefaults()
    }
}
