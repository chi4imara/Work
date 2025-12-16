import Foundation
import SwiftUI
import Combine

class CandleStore: ObservableObject {
    @Published var candles: [Candle] = []
    @Published var searchText = ""
    @Published var selectedFilter: FilterType = .all
    @Published var selectedMoodFilter: Mood?
    @Published var selectedSeasonFilter: Season?
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case favorites = "Favorites"
        case mood = "By Mood"
        case season = "By Season"
    }
    
    private let userDefaults = UserDefaults.standard
    private let candlesKey = "SavedCandles"
    
    init() {
        loadCandles()
    }
    
    var filteredCandles: [Candle] {
        var filtered = candles
        
        if !searchText.isEmpty {
            filtered = filtered.filter { candle in
                candle.name.localizedCaseInsensitiveContains(searchText) ||
                candle.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedFilter {
        case .all:
            break
        case .favorites:
            filtered = filtered.filter { $0.isFavorite }
        case .mood:
            if let mood = selectedMoodFilter {
                filtered = filtered.filter { $0.mood == mood }
            }
        case .season:
            if let season = selectedSeasonFilter {
                filtered = filtered.filter { $0.season == season }
            }
        }
        
        return filtered.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func addCandle(_ candle: Candle) {
        candles.append(candle)
        saveCandles()
    }
    
    func updateCandle(_ candle: Candle) {
        if let index = candles.firstIndex(where: { $0.id == candle.id }) {
            candles[index] = candle
            saveCandles()
        }
    }
    
    func deleteCandle(_ candle: Candle) {
        candles.removeAll { $0.id == candle.id }
        saveCandles()
    }
    
    func toggleFavorite(for candle: Candle) {
        if let index = candles.firstIndex(where: { $0.id == candle.id }) {
            candles[index].isFavorite.toggle()
            saveCandles()
        }
    }
    
    private func saveCandles() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        if let encoded = try? encoder.encode(candles) {
            userDefaults.set(encoded, forKey: candlesKey)
        }
    }
    
    private func loadCandles() {
        if let data = userDefaults.data(forKey: candlesKey) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            if let decoded = try? decoder.decode([Candle].self, from: data) {
                candles = decoded
            }
        }
    }
}
