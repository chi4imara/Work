import Foundation
import SwiftUI
import Combine

class PhotoshootViewModel: ObservableObject {
    @Published var scenarios: [PhotoshootScenario] = [] {
        didSet {
            saveScenarios()
        }
    }
    @Published var searchText: String = ""
    @Published var filterOptions = FilterOptions()
    @Published var sortOption: SortOption = .dateCreated {
        didSet {
            saveSortOption()
        }
    }
    @Published var selectedCategory: ScenarioCategory? = nil
    
    enum SortOption: String, CaseIterable, Codable {
        case dateCreated = "Date Created"
        case theme = "Theme"
        case status = "Status"
        case date = "Shoot Date"
        
        var systemImage: String {
            switch self {
            case .dateCreated:
                return "calendar"
            case .theme:
                return "textformat.abc"
            case .status:
                return "checkmark.circle"
            case .date:
                return "calendar.badge.clock"
            }
        }
    }
    
    private let scenariosKey = "SavedScenarios"
    private let sortOptionKey = "SavedSortOption"
    private let hasLoadedInitialDataKey = "HasLoadedInitialData"
    
    init() {
        loadScenarios()
        loadSortOption()
        
        if scenarios.isEmpty && !UserDefaults.standard.bool(forKey: hasLoadedInitialDataKey) {
            UserDefaults.standard.set(true, forKey: hasLoadedInitialDataKey)
        }
    }
    
    var filteredScenarios: [PhotoshootScenario] {
        var filtered = scenarios
        
        if !searchText.isEmpty {
            filtered = filtered.filter { scenario in
                scenario.theme.localizedCaseInsensitiveContains(searchText) ||
                scenario.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filtered = filtered.filter { filterOptions.selectedStatuses.contains($0.status) }
        
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        } else {
            filtered = filtered.filter { filterOptions.selectedCategories.contains($0.category) }
        }
        
        if !filterOptions.locationFilter.isEmpty {
            filtered = filtered.filter { $0.location.localizedCaseInsensitiveContains(filterOptions.locationFilter) }
        }
        
        if let dateRange = filterOptions.dateRange {
            filtered = filtered.filter { dateRange.contains($0.date) }
        }
        
        return sortScenarios(filtered)
    }
    
    var scenariosByCategory: [ScenarioCategory: [PhotoshootScenario]] {
        Dictionary(grouping: scenarios) { $0.category }
    }
    
    func addScenario(_ scenario: PhotoshootScenario) {
        scenarios.append(scenario)
    }
    
    func updateScenario(_ scenario: PhotoshootScenario) {
        if let index = scenarios.firstIndex(where: { $0.id == scenario.id }) {
            scenarios[index] = scenario
        }
    }
    
    func deleteScenario(_ scenario: PhotoshootScenario) {
        scenarios.removeAll { $0.id == scenario.id }
    }
    
    func markAsCompleted(_ scenario: PhotoshootScenario) {
        if let index = scenarios.firstIndex(where: { $0.id == scenario.id }) {
            var updatedScenario = scenarios[index]
            updatedScenario.status = .completed
            scenarios[index] = updatedScenario
        }
    }
    
    private func sortScenarios(_ scenarios: [PhotoshootScenario]) -> [PhotoshootScenario] {
        switch sortOption {
        case .dateCreated:
            return scenarios.sorted { $0.createdAt > $1.createdAt }
        case .theme:
            return scenarios.sorted { $0.theme < $1.theme }
        case .status:
            return scenarios.sorted { $0.status.rawValue < $1.status.rawValue }
        case .date:
            return scenarios.sorted { $0.date < $1.date }
        }
    }
    
    func resetFilters() {
        filterOptions.reset()
        selectedCategory = nil
        searchText = ""
    }
    
    private func saveScenarios() {
        if let encoded = try? JSONEncoder().encode(scenarios) {
            UserDefaults.standard.set(encoded, forKey: scenariosKey)
        }
    }
    
    private func loadScenarios() {
        if let data = UserDefaults.standard.data(forKey: scenariosKey),
           let decoded = try? JSONDecoder().decode([PhotoshootScenario].self, from: data) {
            scenarios = decoded
        }
    }
    
    private func saveSortOption() {
        if let encoded = try? JSONEncoder().encode(sortOption) {
            UserDefaults.standard.set(encoded, forKey: sortOptionKey)
        }
    }
    
    private func loadSortOption() {
        if let data = UserDefaults.standard.data(forKey: sortOptionKey),
           let decoded = try? JSONDecoder().decode(SortOption.self, from: data) {
            sortOption = decoded
        }
    }
}
