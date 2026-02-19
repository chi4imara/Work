import Foundation
import SwiftUI
import StoreKit
import Combine

class WorkoutViewModel: ObservableObject {
    @Published var records: [WorkoutRecord] = []
    @Published var currentRecord = WorkoutRecord()
    @Published var isShowingRecordSaved = false
    @Published var savedRecord: WorkoutRecord?
    
    private let userDefaults = UserDefaults.standard
    private let recordsKey = "workout_records"
    
    init() {
        loadRecords()
    }
    
    func saveRecord() {
        let newRecord = WorkoutRecord(
            date: currentRecord.date,
            exercise: currentRecord.exercise,
            weight: currentRecord.weight,
            repetitions: currentRecord.repetitions,
            comment: currentRecord.comment
        )
        
        records.append(newRecord)
        savedRecord = newRecord
        saveRecords()
        clearCurrentRecord()
        isShowingRecordSaved = true
    }
    
    func updateRecord(_ record: WorkoutRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records[index] = record
            saveRecords()
        }
    }
    
    func deleteRecord(_ record: WorkoutRecord) {
        records.removeAll { $0.id == record.id }
        saveRecords()
    }
    
    func clearCurrentRecord() {
        currentRecord = WorkoutRecord()
    }
    
    func getExerciseGroups() -> [ExerciseGroup] {
        let groupedRecords = Dictionary(grouping: records) { $0.exercise }
        return groupedRecords.map { ExerciseGroup(name: $0.key, records: $0.value) }
            .sorted { $0.recordCount > $1.recordCount }
    }
    
    func getRecordsForExercise(_ exerciseName: String) -> [WorkoutRecord] {
        return records.filter { $0.exercise == exerciseName }
            .sorted { $0.date > $1.date }
    }
    
    func getSortedRecords() -> [WorkoutRecord] {
        return records.sorted { $0.date > $1.date }
    }
    
    func getRecord(byId id: UUID) -> WorkoutRecord? {
        return records.first { $0.id == id }
    }
    
    func deleteRecord(byId id: UUID) {
        records.removeAll { $0.id == id }
        saveRecords()
    }
    
    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            userDefaults.set(encoded, forKey: recordsKey)
        }
    }
    
    private func loadRecords() {
        if let data = userDefaults.data(forKey: recordsKey),
           let decoded = try? JSONDecoder().decode([WorkoutRecord].self, from: data) {
            records = decoded
        }
    }
}

class AppStateViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .newRecord
    @Published var isShowingSplash = true
    @Published var isShowingOnboarding = false
    @Published var hasCompletedOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "has_completed_onboarding"
    
    init() {
        hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isShowingSplash = false
            if !self.hasCompletedOnboarding {
                self.isShowingOnboarding = true
            }
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        isShowingOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
