import Foundation
import SwiftUI
import Combine

class FragranceViewModel: ObservableObject {
    @Published var fragrances: [Fragrance] = []
    @Published var searchText: String = ""
    @Published var currentFilter: FragranceFilter = .all
    @Published var showingOnboarding: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let fragrancesKey = "SavedFragrances"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadFragrances()
        checkOnboardingStatus()
    }
    
    var filteredFragrances: [Fragrance] {
        var result = fragrances
        
        if !searchText.isEmpty {
            result = result.filter { fragrance in
                fragrance.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch currentFilter {
        case .all:
            break
        case .favorites:
            result = result.filter { $0.isFavorite }
        case .season(let season):
            result = result.filter { $0.season == season }
        case .occasion(let occasion):
            result = result.filter { $0.occasions.localizedCaseInsensitiveContains(occasion) }
        case .search(let query):
            result = result.filter { fragrance in
                fragrance.name.localizedCaseInsensitiveContains(query)
            }
        }
        
        return result.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var favoriteFragrances: [Fragrance] {
        return fragrances.filter { $0.isFavorite }.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var seasonCategories: [Category] {
        return Season.allCases.compactMap { season in
            let count = fragrances.filter { $0.season == season }.count
            return count > 0 ? Category(name: season.displayName, count: count, type: .season(season)) : nil
        }
    }
    
    var occasionCategories: [Category] {
        let allOccasions = fragrances.flatMap { fragrance in
            fragrance.occasions.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }.filter { !$0.isEmpty }
        
        let occasionCounts = Dictionary(grouping: allOccasions, by: { $0.lowercased() })
            .mapValues { $0.count }
        
        return occasionCounts.map { occasion, count in
            Category(name: occasion.capitalized, count: count, type: .occasion(occasion))
        }.sorted { $0.count > $1.count }
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
    
    func toggleFavorite(_ fragrance: Fragrance) {
        if let index = fragrances.firstIndex(where: { $0.id == fragrance.id }) {
            fragrances[index].isFavorite.toggle()
            saveFragrances()
        }
    }
    
    func getFragrance(by id: UUID) -> Fragrance? {
        return fragrances.first { $0.id == id }
    }
    
    func applyFilter(_ filter: FragranceFilter) {
        currentFilter = filter
    }
    
    func clearFilter() {
        currentFilter = .all
        searchText = ""
    }
    
    func completeOnboarding() {
        showingOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    private func checkOnboardingStatus() {
        showingOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    private func saveFragrances() {
        if let encoded = try? JSONEncoder().encode(fragrances) {
            userDefaults.set(encoded, forKey: fragrancesKey)
        }
    }
    
    private func loadFragrances() {
        if let data = userDefaults.data(forKey: fragrancesKey),
           let decodedFragrances = try? JSONDecoder().decode([Fragrance].self, from: data) {
            fragrances = decodedFragrances
        } else {
            fragrances = []
        }
    }
}
