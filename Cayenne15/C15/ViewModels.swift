import Foundation
import SwiftUI
import Combine

class CarRecordsViewModel: ObservableObject {
    @Published var records: [CarRecord] = []
    
    private let userDefaults = UserDefaults.standard
    private let recordsKey = "CarRecords"
    
    init() {
        loadRecords()
    }
    
    func addRecord(_ record: CarRecord) {
        records.insert(record, at: 0)
        saveRecords()
    }
    
    func updateRecord(_ record: CarRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records[index] = record
            saveRecords()
        }
    }
    
    func deleteRecord(_ record: CarRecord) {
        records.removeAll { $0.id == record.id }
        saveRecords()
    }
    
    func getRecord(by id: UUID) -> CarRecord? {
        return records.first { $0.id == id }
    }
    
    func getRecords(for type: RecordType) -> [CarRecord] {
        return records.filter { $0.type == type }
    }
    
    func getStatistics() -> [RecordType: Int] {
        var stats: [RecordType: Int] = [:]
        for type in RecordType.allCases {
            stats[type] = records.filter { $0.type == type }.count
        }
        return stats
    }
    
    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            userDefaults.set(encoded, forKey: recordsKey)
        }
    }
    
    private func loadRecords() {
        if let data = userDefaults.data(forKey: recordsKey),
           let decoded = try? JSONDecoder().decode([CarRecord].self, from: data) {
            records = decoded
        }
    }
}

class AppStateViewModel: ObservableObject {
    @Published var showSplash = true
    @Published var showOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @Published var isFirstLaunch = true
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        checkFirstLaunch()
    }
    
    func completeSplash() {
        showSplash = false
        if isFirstLaunch {
            showOnboarding = true
        }
    }
    
    func completeOnboarding() {
        showOnboarding = true
        userDefaults.set(true, forKey: "hasCompletedOnboarding")
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
}
