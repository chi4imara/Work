import Foundation
import SwiftUI
import Combine

class StyleViewModel: ObservableObject {
    @Published var styles: [Style] = []
    @Published var searchText: String = ""
    @Published var selectedSortOption: SortOption = .alphabetical
    @Published var isShowingOnboarding: Bool = true
    @Published var isShowingSplash: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let stylesKey = "SavedStyles"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadStyles()
        checkOnboardingStatus()
    }
    
    var filteredStyles: [Style] {
        var filtered = styles
        
        if !searchText.isEmpty {
            filtered = filtered.filter { style in
                style.name.localizedCaseInsensitiveContains(searchText) ||
                style.description.localizedCaseInsensitiveContains(searchText) ||
                style.shape.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedSortOption {
        case .alphabetical:
            filtered = filtered.sorted { $0.name < $1.name }
        case .haircuts:
            filtered = filtered.filter { $0.category == .haircut }
        case .beards:
            filtered = filtered.filter { $0.category == .beard }
        case .favorites:
            filtered = filtered.filter { $0.isFavorite }
        }
        
        return filtered
    }
    
    var favoriteStyles: [Style] {
        return styles.filter { $0.isFavorite }
    }
    
    var categoryGroups: [CategoryGroup] {
        var groups: [CategoryGroup] = []
        
        let haircutCount = styles.filter { $0.category == .haircut }.count
        let beardCount = styles.filter { $0.category == .beard }.count
        
        if haircutCount > 0 {
            groups.append(CategoryGroup(name: "Haircuts", count: haircutCount, type: .category(.haircut)))
        }
        
        if beardCount > 0 {
            groups.append(CategoryGroup(name: "Beards", count: beardCount, type: .category(.beard)))
        }
        
        let lengthCounts = Dictionary(grouping: styles, by: { $0.length })
        for (length, styleArray) in lengthCounts {
            if !length.isEmpty {
                groups.append(CategoryGroup(name: "Length: \(length)", count: styleArray.count, type: .shape(length)))
            }
        }
        
        let shapeCounts = Dictionary(grouping: styles, by: { $0.shape })
        for (shape, styleArray) in shapeCounts {
            if !shape.isEmpty {
                groups.append(CategoryGroup(name: "Shape: \(shape)", count: styleArray.count, type: .shape(shape)))
            }
        }
        
        return groups
    }
    
    func addStyle(_ style: Style) {
        styles.append(style)
        saveStyles()
    }
    
    func updateStyle(_ updatedStyle: Style) {
        guard let index = styles.firstIndex(where: { $0.id == updatedStyle.id }) else { return }
        var updatedStyles = styles
        updatedStyles[index] = updatedStyle
        styles = updatedStyles
        saveStyles()
    }
    
    func deleteStyle(_ style: Style) {
        styles = styles.filter { $0.id != style.id }
        saveStyles()
    }
    
    func deleteStyle(byId id: UUID) {
        styles = styles.filter { $0.id != id }
        saveStyles()
    }
    
    func toggleFavorite(for style: Style) {
        guard let index = styles.firstIndex(where: { $0.id == style.id }) else { return }
        var updatedStyles = styles
        updatedStyles[index].isFavorite.toggle()
        styles = updatedStyles
        saveStyles()
    }
    
    func getStylesForCategory(_ categoryType: CategoryType) -> [Style] {
        switch categoryType {
        case .category(let category):
            return styles.filter { $0.category == category }
        case .length(let length):
            return styles.filter { $0.length == length.rawValue }
        case .shape(let shape):
            return styles.filter { $0.shape == shape || $0.length == shape }
        }
    }
    
    func completeOnboarding() {
        isShowingOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func completeSplash() {
        isShowingSplash = false
    }
    
    private func loadStyles() {
        if let data = userDefaults.data(forKey: stylesKey),
           let decodedStyles = try? JSONDecoder().decode([Style].self, from: data) {
            styles = decodedStyles
        }
    }
    
    private func saveStyles() {
        if let encoded = try? JSONEncoder().encode(styles) {
            userDefaults.set(encoded, forKey: stylesKey)
        }
    }
    
    private func checkOnboardingStatus() {
        isShowingOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
}
