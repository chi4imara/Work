import Foundation
import SwiftUI
import Combine

class FragranceViewModel: ObservableObject {
    @Published var fragrances: [Fragrance] = []
    @Published var searchText: String = ""
    @Published var selectedSeason: Season = .allSeasons
    @Published var customStyles: [String] = []
    
    private let userDefaults = UserDefaults.standard
    private let fragrancesKey = "SavedFragrances"
    private let customStylesKey = "CustomStyles"
    
    init() {
        loadFragrances()
        loadCustomStyles()
    }
    
    var filteredFragrances: [Fragrance] {
        var filtered = fragrances
        
        if selectedSeason != .allSeasons {
            filtered = filtered.filter { $0.season == selectedSeason }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { fragrance in
                fragrance.name.localizedCaseInsensitiveContains(searchText) ||
                fragrance.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var favoriteFragrances: [Fragrance] {
        return fragrances.filter { $0.isFavorite }.sorted { $0.dateAdded > $1.dateAdded }
    }
    
    var seasonCategories: [Category] {
        return Season.allCases.compactMap { season in
            guard season != .allSeasons else { return nil }
            let count = fragrances.filter { $0.season == season }.count
            return Category(name: season.displayName, count: count, type: .season(season))
        }
    }
    
    var styleCategories: [Category] {
        var styles = Set<String>()
        fragrances.forEach { styles.insert($0.style) }
        
        return styles.map { style in
            let count = fragrances.filter { $0.style == style }.count
            return Category(name: style, count: count, type: .style(style))
        }.sorted { $0.name < $1.name }
    }
    
    var allStyles: [String] {
        let predefinedStyles = Style.allCases.compactMap { style in
            style == .custom ? nil : style.displayName
        }
        return predefinedStyles + customStyles
    }
    
    func addFragrance(_ fragrance: Fragrance) {
        fragrances.append(fragrance)
        saveFragrances()
    }
    
    func updateFragrance(_ fragrance: Fragrance) {
        if let index = fragrances.firstIndex(where: { $0.id == fragrance.id }) {
            fragrances[index] = fragrance
            saveFragrances()
        }
    }
    
    func deleteFragrance(_ fragrance: Fragrance) {
        fragrances.removeAll { $0.id == fragrance.id }
        saveFragrances()
    }
    
    func toggleFavorite(for fragrance: Fragrance) {
        if let index = fragrances.firstIndex(where: { $0.id == fragrance.id }) {
            fragrances[index].isFavorite.toggle()
            saveFragrances()
        }
    }
    
    func addCustomStyle(_ style: String) {
        if !customStyles.contains(style) && !Style.allCases.map({ $0.displayName }).contains(style) {
            customStyles.append(style)
            saveCustomStyles()
        }
    }
    
    func getFragrances(for category: Category) -> [Fragrance] {
        switch category.type {
        case .season(let season):
            return fragrances.filter { $0.season == season }
        case .style(let style):
            return fragrances.filter { $0.style == style }
        }
    }
    
    func getFragrance(by id: UUID) -> Fragrance? {
        return fragrances.first { $0.id == id }
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
    
    private func saveCustomStyles() {
        userDefaults.set(customStyles, forKey: customStylesKey)
    }
    
    private func loadCustomStyles() {
        customStyles = userDefaults.stringArray(forKey: customStylesKey) ?? []
    }
    
    func clearSearch() {
        searchText = ""
    }
    
    func resetFilters() {
        selectedSeason = .allSeasons
        searchText = ""
    }
}
