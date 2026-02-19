import Foundation
import SwiftUI
import Combine

class JewelryViewModel: ObservableObject {
    static let shared = JewelryViewModel()
    
    @Published var jewelries: [Jewelry] = []
    @Published var searchText: String = ""
    @Published var customStyles: [CustomStyle] = []
    
    private let userDefaults = UserDefaults.standard
    private let jewelriesKey = "SavedJewelries"
    private let customStylesKey = "CustomStyles"
    
    private init() {
        loadJewelries()
        loadCustomStyles()
    }
    
    var filteredJewelries: [Jewelry] {
        if searchText.isEmpty {
            return jewelries
        } else {
            return jewelries.filter { jewelry in
                jewelry.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var favoriteJewelries: [Jewelry] {
        return jewelries.filter { $0.isFavorite }
    }
    
    var styleGroups: [String: [Jewelry]] {
        Dictionary(grouping: jewelries) { $0.style }
    }
    
    var availableStyles: [String] {
        var styles = JewelryStyle.allCases
            .filter { $0 != .custom }
            .map { $0.rawValue }
        
        let customStyleNames = customStyles.map { $0.name }
        styles.append(contentsOf: customStyleNames)
        
        return styles
    }
    
    func addJewelry(_ jewelry: Jewelry) {
        jewelries.append(jewelry)
        saveJewelries()
    }
    
    func updateJewelry(_ jewelry: Jewelry) {
        if let index = jewelries.firstIndex(where: { $0.id == jewelry.id }) {
            jewelries[index] = jewelry
            saveJewelries()
        }
    }
    
    func deleteJewelry(_ jewelry: Jewelry) {
        jewelries.removeAll { $0.id == jewelry.id }
        saveJewelries()
    }
    
    func toggleFavorite(_ jewelry: Jewelry) {
        if let index = jewelries.firstIndex(where: { $0.id == jewelry.id }) {
            jewelries[index].isFavorite.toggle()
            saveJewelries()
        }
    }
    
    func addCustomStyle(_ styleName: String) {
        let trimmedName = styleName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let exists = customStyles.contains { existingStyle in
            existingStyle.name.lowercased() == trimmedName.lowercased()
        }
        
        if !exists {
            let customStyle = CustomStyle(name: trimmedName)
            customStyles.append(customStyle)
            saveCustomStyles()
            objectWillChange.send()
        }
    }
    
    func getJewelriesForStyle(_ styleName: String) -> [Jewelry] {
        return jewelries.filter { $0.style == styleName }
    }
    
    func getStyleCount(_ styleName: String) -> Int {
        return jewelries.filter { $0.style == styleName }.count
    }
    
    private func saveJewelries() {
        if let encoded = try? JSONEncoder().encode(jewelries) {
            userDefaults.set(encoded, forKey: jewelriesKey)
        }
    }
    
    private func loadJewelries() {
        if let data = userDefaults.data(forKey: jewelriesKey),
           let decoded = try? JSONDecoder().decode([Jewelry].self, from: data) {
            jewelries = decoded
        }
    }
    
    private func saveCustomStyles() {
        if let encoded = try? JSONEncoder().encode(customStyles) {
            userDefaults.set(encoded, forKey: customStylesKey)
        }
    }
    
    private func loadCustomStyles() {
        if let data = userDefaults.data(forKey: customStylesKey),
           let decoded = try? JSONDecoder().decode([CustomStyle].self, from: data) {
            customStyles = decoded
        }
    }
}
