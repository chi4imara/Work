import Foundation
import SwiftUI
import Combine

class ScentCombinationsViewModel: ObservableObject {
    @Published var combinations: [ScentCombination] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: ScentCategory? = nil
    
    private let userDefaults = UserDefaults.standard
    private let combinationsKey = "SavedCombinations"
    
    init() {
        loadCombinations()
    }
    
    var filteredCombinations: [ScentCombination] {
        var filtered = combinations
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { combination in
                combination.name.localizedCaseInsensitiveContains(searchText) ||
                combination.perfumeAroma.localizedCaseInsensitiveContains(searchText) ||
                combination.candleAroma.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func addCombination(_ combination: ScentCombination) {
        combinations.append(combination)
        saveCombinations()
    }
    
    func updateCombination(_ combination: ScentCombination) {
        if let index = combinations.firstIndex(where: { $0.id == combination.id }) {
            combinations[index] = combination
            saveCombinations()
        }
    }
    
    func deleteCombination(_ combination: ScentCombination) {
        combinations.removeAll { $0.id == combination.id }
        saveCombinations()
    }
    
    func clearCategoryFilter() {
        selectedCategory = nil
    }
    
    func setCategoryFilter(_ category: ScentCategory) {
        selectedCategory = category
    }
    
    private func saveCombinations() {
        if let encoded = try? JSONEncoder().encode(combinations) {
            userDefaults.set(encoded, forKey: combinationsKey)
        }
    }
    
    private func loadCombinations() {
        if let data = userDefaults.data(forKey: combinationsKey),
           let decoded = try? JSONDecoder().decode([ScentCombination].self, from: data) {
            combinations = decoded
        }
    }
}

class CategoriesViewModel: ObservableObject {
    @Published var combinations: [ScentCombination] = []
    
    var categoryCounts: [ScentCategory: Int] {
        var counts: [ScentCategory: Int] = [:]
        for category in ScentCategory.allCases {
            counts[category] = combinations.filter { $0.category == category }.count
        }
        return counts
    }
    
    func updateCombinations(_ combinations: [ScentCombination]) {
        self.combinations = combinations
    }
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    var sortedNotes: [Note] {
        return notes.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            userDefaults.set(encoded, forKey: notesKey)
        }
    }
    
    
    private func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
        notes = decoded
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showingRateApp = false
    
    func rateApp() {
        showingRateApp = true
    }
    
    func openTermsAndConditions() {
        if let url = URL(string: "https://doc-hosting.flycricket.io/moodpair-aromamix-terms-of-use/b83c8d25-7371-40ff-bff4-4cb170ef5a1e/terms") {
            UIApplication.shared.open(url)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://doc-hosting.flycricket.io/moodpair-aromamix-privacy-policy/88f02c8d-dd4d-4074-8bb4-b97dcf2d0bab/privacy") {
            UIApplication.shared.open(url)
        }
    }
    
    func contactSupport() {
        if let url = URL(string: "https://forms.gle/zcNyjQk1Cw8b7XQK7") {
            UIApplication.shared.open(url)
        }
    }
}

class MainAppViewModel: ObservableObject {
    @Published var selectedTab: TabSelection = .combinations
    let appState = AppState()
    
    let scentCombinationsViewModel = ScentCombinationsViewModel()
    let categoriesViewModel = CategoriesViewModel()
    let notesViewModel = NotesViewModel()
    let settingsViewModel = SettingsViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        scentCombinationsViewModel.$combinations
            .sink { [weak self] combinations in
                self?.categoriesViewModel.updateCombinations(combinations)
            }
            .store(in: &cancellables)
        
        appState.$isLoading
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        appState.$hasCompletedOnboarding
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
