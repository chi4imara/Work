import Foundation
import SwiftUI
import Combine

class VictoryViewModel: ObservableObject {
    @Published var victories: [Victory] = []
    @Published var searchText: String = ""
    @Published var selectedDate: Date = Date()
    @Published var showOnlyFavorites: Bool = false
    @Published var selectedMonth: Date = Date()
    
    private let userDefaults = UserDefaults.standard
    private let victoriesKey = "SavedVictories"
    
    init() {
        loadVictories()
    }
    
    func addVictory(text: String, date: Date = Date()) {
        let victory = Victory(text: text, date: date)
        victories.append(victory)
        saveVictories()
    }
    
    func updateVictory(_ victory: Victory, text: String) {
        if let index = victories.firstIndex(where: { $0.id == victory.id }) {
            victories[index].text = text
            saveVictories()
        }
    }
    
    func toggleFavorite(_ victory: Victory) {
        if let index = victories.firstIndex(where: { $0.id == victory.id }) {
            victories[index].isFavorite.toggle()
            objectWillChange.send()
            saveVictories()
        }
    }
    
    func deleteVictory(_ victory: Victory) {
        victories.removeAll { $0.id == victory.id }
        saveVictories()
    }
    
    var todayVictory: Victory? {
        victories.first { $0.isToday }
    }
    
    var favoriteVictories: [Victory] {
        victories.filter { $0.isFavorite }.sorted { $0.date > $1.date }
    }
    
    var filteredVictories: [Victory] {
        var filtered = victories
        
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.text.localizedCaseInsensitiveContains(searchText) 
            }
        }
        
        if showOnlyFavorites {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    func victoriesForMonth(_ date: Date) -> [Victory] {
        let calendar = Calendar.current
        return victories.filter { victory in
            calendar.isDate(victory.date, equalTo: date, toGranularity: .month)
        }
    }
    
    func victoryForDate(_ date: Date) -> Victory? {
        victories.first { Victory.isSameDay($0.date, date) }
    }
    
    func hasVictoryForDate(_ date: Date) -> Bool {
        victories.contains { Victory.isSameDay($0.date, date) }
    }
    
    var totalVictories: Int {
        victories.count
    }
    
    var totalFavorites: Int {
        victories.filter { $0.isFavorite }.count
    }
    
    var mostActiveMonth: String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let monthCounts = Dictionary(grouping: victories) { victory in
            calendar.dateInterval(of: .month, for: victory.date)?.start ?? victory.date
        }.mapValues { $0.count }
        
        guard let mostActiveDate = monthCounts.max(by: { $0.value < $1.value })?.key else {
            return "No data"
        }
        
        return formatter.string(from: mostActiveDate)
    }
    
    func victoriesCountByDay(for period: DateInterval) -> [(Date, Int)] {
        let calendar = Calendar.current
        var result: [(Date, Int)] = []
        
        var currentDate = period.start
        while currentDate <= period.end {
            let count = victories.filter { 
                calendar.isDate($0.date, inSameDayAs: currentDate) 
            }.count
            result.append((currentDate, count))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return result
    }
    
    var favoritePercentage: Double {
        guard totalVictories > 0 else { return 0 }
        return Double(totalFavorites) / Double(totalVictories) * 100
    }
    
    private func saveVictories() {
        if let encoded = try? JSONEncoder().encode(victories) {
            userDefaults.set(encoded, forKey: victoriesKey)
        }
    }
    
    private func loadVictories() {
        if let data = userDefaults.data(forKey: victoriesKey),
           let decoded = try? JSONDecoder().decode([Victory].self, from: data) {
            victories = decoded
        }
    }
    
    func clearSearch() {
        searchText = ""
        showOnlyFavorites = false
    }
    
    func canAddVictoryForToday() -> Bool {
        todayVictory == nil
    }
}
