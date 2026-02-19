import SwiftUI
import Combine
import UIKit

final class AppDataStore: ObservableObject {
    @Published var rituals: [Ritual] = []
    @Published var dailyEntries: [DailyEntry] = []
    @Published var todayEntry: DailyEntry?
    @Published var todayChallenge: Challenge?
    
    private let calendar = Calendar.current
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isDataLoaded = false
    @Published var dataVersion = UUID()
    
    init() {
        let today = calendar.startOfDay(for: Date())
        rituals = []
        dailyEntries = []
        todayEntry = DailyEntry(date: today)
        todayChallenge = Challenge.dailyChallenges.first ?? Challenge(id: UUID(), title: "Загрузка...", description: "", category: .mindfulness, difficulty: .easy)
        isDataLoaded = false
        
        print("AppDataStore инициализирован")
    }
    
    func setupSaveOnBackground() {
        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                print("App will resign active - saving data")
                self?.saveToStorage()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                print("App did enter background - saving data")
                self?.saveToStorage()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { [weak self] _ in
                print("App will terminate - saving data")
                self?.saveToStorage()
            }
            .store(in: &cancellables)
    }
    
    func loadFromStorage() {
        print("Starting data loading...")
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let loadedRituals = DataManager.shared.loadRituals()
            let loadedEntries = DataManager.shared.loadDailyEntries()
            let today = self.calendar.startOfDay(for: Date())
            let loadedTodayEntry = loadedEntries.first { self.calendar.isDate($0.date, inSameDayAs: today) } ?? DailyEntry(date: today)
            
            print("Loaded from storage - Rituals: \(loadedRituals.count), Entries: \(loadedEntries.count)")
            
            let finalRituals = loadedRituals.isEmpty ? Ritual.defaultRituals : loadedRituals
            
            let dayIndex = self.calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
            let challengeIndex = dayIndex % Challenge.dailyChallenges.count
            let dailyChallenge = Challenge.dailyChallenges[challengeIndex]
            
            DispatchQueue.main.async {
                print("Data loaded, updating UI - Final Rituals: \(finalRituals.count)")
                self.rituals = finalRituals
                self.dailyEntries = loadedEntries.filter { !self.calendar.isDate($0.date, inSameDayAs: today) }
                self.todayEntry = loadedTodayEntry
                self.todayChallenge = dailyChallenge
                self.isDataLoaded = true
                
                self.setupSaveOnBackground()
                
                if loadedRituals.isEmpty && !finalRituals.isEmpty {
                    print("Saving default rituals...")
                    self.saveToStorage()
                }
                self.dataVersion = UUID()
            }
        }
    }
    
    func saveToStorage() {
        print("Saving data to storage...")
        let ritualsToSave = rituals
        var entriesToSave = dailyEntries.filter { entry in
            !calendar.isDate(entry.date, inSameDayAs: Date())
        }
        if let today = todayEntry {
            entriesToSave.append(today)
        }
        
        DataManager.shared.saveRituals(ritualsToSave)
        DataManager.shared.saveDailyEntries(entriesToSave)
        print("Data saved successfully - Rituals: \(ritualsToSave.count), Entries: \(entriesToSave.count)")
    }
    
    func loadSampleData() {
        let today = calendar.startOfDay(for: Date())
        
        let sampleRituals = SampleData.makeSampleRituals()
        let ritualIds = sampleRituals.map(\.id)
        let allSampleEntries = SampleData.makeSampleEntries(ritualIds: ritualIds, today: today)
        
        let todayEntrySample = allSampleEntries.first { calendar.isDate($0.date, inSameDayAs: today) }
        let pastEntries = allSampleEntries.filter { !calendar.isDate($0.date, inSameDayAs: today) }
        
        rituals = sampleRituals
        dailyEntries = pastEntries
        todayEntry = todayEntrySample ?? DailyEntry(date: today)
        
        let dayIndex = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let challengeIndex = dayIndex % Challenge.dailyChallenges.count
        todayChallenge = Challenge.dailyChallenges[challengeIndex]
        
        saveToStorage()
        dataVersion = UUID()
        print("Sample data loaded - Rituals: \(rituals.count), Entries: \(dailyEntries.count + 1)")
    }
    
    private func ensureTodayEntry() {
        let today = calendar.startOfDay(for: Date())
        if todayEntry == nil {
            todayEntry = DailyEntry(date: today)
        }
    }
    
    private func pickTodayChallengeIfNeeded() {
        if todayChallenge == nil {
            let dayIndex = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
            let index = dayIndex % Challenge.dailyChallenges.count
            todayChallenge = Challenge.dailyChallenges[index]
        }
    }
    
    func ritual(byId id: UUID) -> Ritual? { rituals.first { $0.id == id } }
    func updateRitual(_ ritual: Ritual) {
        guard let index = rituals.firstIndex(where: { $0.id == ritual.id }) else { return }
        rituals[index] = ritual
        saveToStorage()
        dataVersion = UUID()
    }
    func deleteRitual(byId id: UUID) { 
        rituals.removeAll { $0.id == id }
        saveToStorage()
        dataVersion = UUID()
    }
    func addRitual(_ ritual: Ritual) { 
        rituals.append(ritual)
        saveToStorage()
        dataVersion = UUID()
    }
    
    func entry(byId id: UUID) -> DailyEntry? {
        if let today = todayEntry, today.id == id { return today }
        return dailyEntries.first { $0.id == id }
    }
    func entry(for date: Date) -> DailyEntry? {
        let day = calendar.startOfDay(for: date)
        if calendar.isDate(day, inSameDayAs: Date()), let today = todayEntry { return today }
        return dailyEntries.first { calendar.isDate($0.date, inSameDayAs: day) }
    }
    func setTodayEntry(_ entry: DailyEntry) { 
        todayEntry = entry
        saveToStorage()
        dataVersion = UUID()
    }
    
    func streakCount() -> Int {
        let allEntries: [DailyEntry] = dailyEntries + (todayEntry.map { [$0] } ?? [])
        let sorted = allEntries.uniqued(by: { calendar.startOfDay(for: $0.date) }).sorted { $0.date > $1.date }
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var current = today
        for e in sorted {
            if calendar.isDate(e.date, inSameDayAs: current), e.isComplete {
                streak += 1
                current = calendar.date(byAdding: .day, value: -1, to: current) ?? current
            } else { break }
        }
        return streak
    }
    
    func completionRate(period: StatsPeriod) -> Double {
        let entries = dailyEntries + (todayEntry.map { [$0] } ?? [])
        let now = Date()
        let start: Date
        switch period {
        case .week: start = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month: start = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .year: start = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        let filtered = entries.filter { $0.date >= start }
        let completed = filtered.filter { $0.isComplete }
        guard !filtered.isEmpty else { return 0 }
        return Double(completed.count) / Double(filtered.count)
    }
    
    func moodDistribution() -> [String: Int] {
        let entries = dailyEntries + (todayEntry.map { [$0] } ?? [])
        var dist: [String: Int] = [:]
        for e in entries {
            if let mood = e.mood { dist[mood.name, default: 0] += 1 }
        }
        return dist
    }
    
    func allEntriesForHistory() -> [DailyEntry] {
        var list = dailyEntries
        if let today = todayEntry, !list.contains(where: { calendar.isDate($0.date, inSameDayAs: Date()) }) {
            list.append(today)
        }
        return list.sorted { $0.date > $1.date }
    }
}

extension Array {
    func uniqued<Key: Hashable>(by keyPath: KeyPath<Element, Key>) -> [Element] {
        var seen = Set<Key>()
        return filter { seen.insert($0[keyPath: keyPath]).inserted }
    }
    func uniqued<Key: Hashable>(by selector: (Element) -> Key) -> [Element] {
        var seen = Set<Key>()
        return filter { seen.insert(selector($0)).inserted }
    }
}
