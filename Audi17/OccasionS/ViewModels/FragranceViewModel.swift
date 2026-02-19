import Foundation
import SwiftUI
import Combine

class FragranceViewModel: ObservableObject {
    @Published var fragrances: [Fragrance] = []
    @Published var filteredFragrances: [Fragrance] = []
    @Published var searchText = ""
    @Published var selectedSeason: Season?
    @Published var selectedFormat: FragranceFormat?
    @Published var selectedNotes = ""
    
    private let userDefaults = UserDefaults.standard
    private let fragrancesKey = "SavedFragrances"
    
    init() {
        loadFragrances()
        updateFilteredFragrances()
    }
    
    func addFragrance(_ fragrance: Fragrance) {
        fragrances.append(fragrance)
        saveFragrances()
        updateFilteredFragrances()
    }
    
    func updateFragrance(_ fragrance: Fragrance) {
        if let index = fragrances.firstIndex(where: { $0.id == fragrance.id }) {
            fragrances[index] = fragrance
            saveFragrances()
            updateFilteredFragrances()
        }
    }
    
    func deleteFragrance(_ fragrance: Fragrance) {
        fragrances.removeAll { $0.id == fragrance.id }
        saveFragrances()
        updateFilteredFragrances()
    }
    
    func applyFilters(season: Season?, format: FragranceFormat?, notes: String) {
        selectedSeason = season
        selectedFormat = format
        selectedNotes = notes
        updateFilteredFragrances()
    }
    
    func clearFilters() {
        selectedSeason = nil
        selectedFormat = nil
        selectedNotes = ""
        searchText = ""
        updateFilteredFragrances()
    }
    
    func updateSearch(_ text: String) {
        searchText = text
        updateFilteredFragrances()
    }
    
    private func updateFilteredFragrances() {
        var filtered = fragrances
        
        if !searchText.isEmpty {
            filtered = filtered.filter { fragrance in
                fragrance.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let season = selectedSeason {
            filtered = filtered.filter { $0.season == season }
        }
        
        if let format = selectedFormat {
            filtered = filtered.filter { $0.format == format }
        }
        
        if !selectedNotes.isEmpty {
            filtered = filtered.filter { fragrance in
                fragrance.notes.joined(separator: " ").localizedCaseInsensitiveContains(selectedNotes)
            }
        }
        
        filteredFragrances = filtered.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    func getFragrancesForSelection(season: Season, format: FragranceFormat) -> [Fragrance] {
        return fragrances.filter { $0.season == season && $0.format == format }
    }
    
    private func saveFragrances() {
        if let encoded = try? JSONEncoder().encode(fragrances) {
            userDefaults.set(encoded, forKey: fragrancesKey)
        }
    }
    
    private func loadFragrances() {
        if let data = userDefaults.data(forKey: fragrancesKey),
           let decoded = try? JSONDecoder().decode([Fragrance].self, from: data) {
            fragrances = decoded
        }
    }
}
