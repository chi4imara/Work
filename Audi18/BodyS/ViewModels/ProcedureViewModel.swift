import Foundation
import SwiftUI
import Combine

class ProcedureViewModel: ObservableObject {
    @Published var procedures: [Procedure] = []
    @Published var schedule = Schedule()
    @Published var dailyProgress: [DailyProgress] = []
    
    private let userDefaults = UserDefaults.standard
    private let proceduresKey = "SavedProcedures"
    private let scheduleKey = "SavedSchedule"
    private let progressKey = "DailyProgress"
    
    init() {
        loadData()
    }
    
    func addProcedure(_ procedure: Procedure) {
        procedures.append(procedure)
        objectWillChange.send()
        saveData()
    }
    
    func updateProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index] = procedure
            saveData()
        }
    }
    
    func deleteProcedure(_ procedure: Procedure) {
        procedures.removeAll { $0.id == procedure.id }
        var updatedSchedule = schedule
        for day in WeekDay.allCases {
            updatedSchedule.removeProcedure(procedure.id, from: day)
        }
        schedule = updatedSchedule
        dailyProgress.removeAll { $0.procedureId == procedure.id }
        objectWillChange.send()
        saveData()
    }
    
    func addProcedureToSchedule(_ procedureId: UUID, day: WeekDay) {
        var updatedSchedule = schedule
        updatedSchedule.addProcedure(procedureId, to: day)
        schedule = updatedSchedule
        objectWillChange.send()
        saveData()
    }
    
    func removeProcedureFromSchedule(_ procedureId: UUID, day: WeekDay) {
        var updatedSchedule = schedule
        updatedSchedule.removeProcedure(procedureId, from: day)
        schedule = updatedSchedule
        objectWillChange.send()
        saveData()
    }
    
    func proceduresForDay(_ day: WeekDay) -> [Procedure] {
        let procedureIds = schedule.procedures(for: day)
        return procedures.filter { procedureIds.contains($0.id) }
    }
    
    func todaysProcedures() -> [Procedure] {
        return proceduresForDay(WeekDay.today)
    }
    
    func toggleStepCompletion(procedureId: UUID, stepIndex: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let progressIndex = dailyProgress.firstIndex(where: { 
            $0.procedureId == procedureId && Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            var updatedProgress = dailyProgress[progressIndex]
            if updatedProgress.completedSteps.contains(stepIndex) {
                updatedProgress.completedSteps.remove(stepIndex)
            } else {
                updatedProgress.completedSteps.insert(stepIndex)
            }
            dailyProgress[progressIndex] = updatedProgress
        } else {
            var newProgress = DailyProgress(date: today, procedureId: procedureId)
            newProgress.completedSteps.insert(stepIndex)
            dailyProgress.append(newProgress)
        }
        objectWillChange.send()
        saveData()
    }
    
    func isStepCompleted(procedureId: UUID, stepIndex: Int) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let progress = dailyProgress.first(where: { 
            $0.procedureId == procedureId && Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            return progress.completedSteps.contains(stepIndex)
        }
        return false
    }
    
    private func saveData() {
        if let proceduresData = try? JSONEncoder().encode(procedures) {
            userDefaults.set(proceduresData, forKey: proceduresKey)
        }
        
        if let scheduleData = try? JSONEncoder().encode(schedule) {
            userDefaults.set(scheduleData, forKey: scheduleKey)
        }
        
        if let progressData = try? JSONEncoder().encode(dailyProgress) {
            userDefaults.set(progressData, forKey: progressKey)
        }
    }
    
    private func loadData() {
        if let proceduresData = userDefaults.data(forKey: proceduresKey),
           let decodedProcedures = try? JSONDecoder().decode([Procedure].self, from: proceduresData) {
            procedures = decodedProcedures
        }
        
        if let scheduleData = userDefaults.data(forKey: scheduleKey),
           let decodedSchedule = try? JSONDecoder().decode(Schedule.self, from: scheduleData) {
            schedule = decodedSchedule
        }
        
        if let progressData = userDefaults.data(forKey: progressKey),
           let decodedProgress = try? JSONDecoder().decode([DailyProgress].self, from: progressData) {
            dailyProgress = decodedProgress
        }
    }
}
