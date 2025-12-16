import Foundation
import SwiftUI
import Combine

class ScentViewModel: ObservableObject {
    @Published var entries: [ScentEntry] = []
    @Published var todayEntry: ScentEntry?
    @Published var selectedDate = Date()
    @Published var searchText = ""
    @Published var isLoading = false
    
    private let dataManager = DataManager.shared
    
    init() {
        loadEntries()
        checkTodayEntry()
    }
        
    func loadEntries() {
        self.entries = dataManager.loadScentEntries()
    }
    
    func saveEntries() {
        dataManager.saveScentEntries(entries)
    }
    
    func checkTodayEntry() {
        let today = Calendar.current.startOfDay(for: Date())
        todayEntry = entries.first { Calendar.current.isDate($0.date, inSameDayAs: today) }
    }
        
    func addEntry(scent: String, location: String, emotion: Emotion, comment: String? = nil) {
        let today = Calendar.current.startOfDay(for: Date())
        
        entries.removeAll { Calendar.current.isDate($0.date, inSameDayAs: today) }
        
        let newEntry = ScentEntry(date: today, scent: scent, location: location, emotion: emotion, comment: comment)
        entries.insert(newEntry, at: 0)
        todayEntry = newEntry
        saveEntries()
    }
    
    func updateEntry(_ entry: ScentEntry, scent: String, location: String, emotion: Emotion, comment: String? = nil) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].scent = scent
            entries[index].location = location
            entries[index].emotion = emotion
            entries[index].comment = comment
            
            if Calendar.current.isDate(entry.date, inSameDayAs: Date()) {
                todayEntry = entries[index]
            }
            
            saveEntries()
        }
    }
    
    func deleteEntry(_ entry: ScentEntry) {
        entries.removeAll { $0.id == entry.id }
        
        if Calendar.current.isDate(entry.date, inSameDayAs: Date()) {
            todayEntry = nil
        }
        
        saveEntries()
    }
        
    func getEntry(for date: Date) -> ScentEntry? {
        return entries.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getRecentEntries(limit: Int = 5) -> [ScentEntry] {
        return Array(entries.prefix(limit))
    }
    
    func searchEntries() -> [ScentEntry] {
        if searchText.isEmpty {
            return entries
        }
        return entries.filter { 
            $0.scent.localizedCaseInsensitiveContains(searchText) ||
            $0.location.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func getDatesWithEntries() -> Set<Date> {
        return Set(entries.map { Calendar.current.startOfDay(for: $0.date) })
    }
        
    func getMostFrequentScents() -> [(scent: String, count: Int)] {
        let scentCounts = Dictionary(grouping: entries, by: { $0.scent })
            .mapValues { $0.count }
        
        return scentCounts.sorted { $0.value > $1.value }
            .map { (scent: $0.key, count: $0.value) }
    }
    
    func getEmotionStatistics() -> [(emotion: Emotion, count: Int)] {
        let emotionCounts = Dictionary(grouping: entries, by: { $0.emotion })
            .mapValues { $0.count }
        
        return emotionCounts.sorted { $0.value > $1.value }
            .map { (emotion: $0.key, count: $0.value) }
    }
    
    func getUniqueScents() -> [(scent: String, count: Int, dominantEmotion: Emotion)] {
        let groupedByScent = Dictionary(grouping: entries, by: { $0.scent })
        
        return groupedByScent.map { (scent, entries) in
            let emotionCounts = Dictionary(grouping: entries, by: { $0.emotion })
                .mapValues { $0.count }
            let dominantEmotion = emotionCounts.max { $0.value < $1.value }?.key ?? .calm
            
            return (scent: scent, count: entries.count, dominantEmotion: dominantEmotion)
        }.sorted { $0.count > $1.count }
    }
}
