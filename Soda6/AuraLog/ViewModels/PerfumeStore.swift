import Foundation
import SwiftUI
import Combine

class PerfumeStore: ObservableObject {
    @Published var perfumes: [Perfume] = []
    @Published var combinations: [Combination] = []
    @Published var hasSeenOnboarding: Bool = false
    
    private let perfumesKey = "SavedPerfumes"
    private let combinationsKey = "SavedCombinations"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadData()
    }
    
    func addPerfume(_ perfume: Perfume) {
        perfumes.append(perfume)
        savePerfumes()
    }
    
    func updatePerfume(_ perfume: Perfume) {
        if let index = perfumes.firstIndex(where: { $0.id == perfume.id }) {
            perfumes[index] = perfume
            savePerfumes()
        }
    }
    
    func deletePerfume(_ perfume: Perfume) {
        perfumes.removeAll { $0.id == perfume.id }
        savePerfumes()
    }
    
    func incrementUsage(for perfume: Perfume) {
        if let index = perfumes.firstIndex(where: { $0.id == perfume.id }) {
            perfumes[index].usageCount += 1
            savePerfumes()
        }
    }
    
    func addCombination(_ combination: Combination) {
        combinations.append(combination)
        saveCombinations()
    }
    
    func deleteCombination(_ combination: Combination) {
        combinations.removeAll { $0.id == combination.id }
        saveCombinations()
    }
    
    var topUsedPerfumes: [Perfume] {
        perfumes.sorted { $0.usageCount > $1.usageCount }.prefix(5).map { $0 }
    }
    
    var perfumesBySeason: [Perfume.Season: Int] {
        Dictionary(grouping: perfumes, by: { $0.season })
            .mapValues { $0.count }
    }
    
    var perfumesByMood: [Perfume.Mood: Int] {
        Dictionary(grouping: perfumes, by: { $0.mood })
            .mapValues { $0.count }
    }
    
    var totalUsages: Int {
        perfumes.reduce(0) { $0 + $1.usageCount }
    }
    
    func filteredPerfumes(searchText: String, selectedSeason: Perfume.Season?, selectedMood: Perfume.Mood?) -> [Perfume] {
        var filtered = perfumes
        
        if !searchText.isEmpty {
            filtered = filtered.filter { perfume in
                perfume.name.localizedCaseInsensitiveContains(searchText) ||
                perfume.brand.localizedCaseInsensitiveContains(searchText) ||
                perfume.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let season = selectedSeason {
            filtered = filtered.filter { $0.season == season }
        }
        
        if let mood = selectedMood {
            filtered = filtered.filter { $0.mood == mood }
        }
        
        return filtered
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
    
    private func loadData() {
        loadPerfumes()
        loadCombinations()
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    private func loadPerfumes() {
        if let data = UserDefaults.standard.data(forKey: perfumesKey),
           let decodedPerfumes = try? JSONDecoder().decode([Perfume].self, from: data) {
            perfumes = decodedPerfumes
        }
    }
    
    private func savePerfumes() {
        if let encoded = try? JSONEncoder().encode(perfumes) {
            UserDefaults.standard.set(encoded, forKey: perfumesKey)
        }
    }
    
    private func loadCombinations() {
        if let data = UserDefaults.standard.data(forKey: combinationsKey),
           let decodedCombinations = try? JSONDecoder().decode([Combination].self, from: data) {
            combinations = decodedCombinations
        }
    }
    
    private func saveCombinations() {
        if let encoded = try? JSONEncoder().encode(combinations) {
            UserDefaults.standard.set(encoded, forKey: combinationsKey)
        }
    }
}
