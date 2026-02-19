import Foundation
import SwiftUI
import Combine

class ManicureViewModel: ObservableObject {
    @Published var manicures: [Manicure] = []
    @Published var masters: [Master] = []
    @Published var colors: [ManicureColor] = []
    @Published var searchText: String = ""
    @Published var isFirstLaunch: Bool = true
    @Published var showOnboarding: Bool = false
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
        checkFirstLaunch()
    }
    
    private func loadData() {
        loadManicures()
        loadMasters()
        restoreMastersFromManicures()
        if !masters.isEmpty {
            saveMasters()
        }
        updateColors()
    }
    
    private func loadManicures() {
        if let data = userDefaults.data(forKey: Constants.UserDefaults.manicuresKey),
           let savedManicures = try? JSONDecoder().decode([Manicure].self, from: data) {
            self.manicures = savedManicures
        }
    }
    
    private func loadMasters() {
        if let data = userDefaults.data(forKey: Constants.UserDefaults.mastersKey),
           let savedMasters = try? JSONDecoder().decode([Master].self, from: data) {
            self.masters = savedMasters
        }
    }
    
    private func restoreMastersFromManicures() {
        var hasNewMasters = false
        
        for manicure in manicures {
            let masterFromManicure = manicure.master
            
            let existsById = masters.contains(where: { $0.id == masterFromManicure.id })
            
            let existsByName = masters.contains(where: { $0.name.lowercased() == masterFromManicure.name.lowercased() })
            
            if !existsById && !existsByName {
                masters.append(masterFromManicure)
                hasNewMasters = true
            }
        }
        
        if hasNewMasters {
            saveMasters()
        }
    }
    
    private func saveManicures() {
        if let data = try? JSONEncoder().encode(manicures) {
            userDefaults.set(data, forKey: Constants.UserDefaults.manicuresKey)
        }
    }
    
    private func saveMasters() {
        if let data = try? JSONEncoder().encode(masters) {
            userDefaults.set(data, forKey: Constants.UserDefaults.mastersKey)
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: Constants.UserDefaults.firstLaunchKey)
        if isFirstLaunch {
            showOnboarding = true
        }
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: Constants.UserDefaults.firstLaunchKey)
        isFirstLaunch = false
        showOnboarding = false
    }
    
    func addManicure(_ manicure: Manicure) {
        manicures.append(manicure)
        addMasterIfNeeded(manicure.master)
        saveManicures()
        updateColors()
    }
    
    func updateManicure(_ manicure: Manicure) {
        if let index = manicures.firstIndex(where: { $0.id == manicure.id }) {
            manicures[index] = manicure
            addMasterIfNeeded(manicure.master)
            saveManicures()
            updateColors()
        }
    }
    
    func deleteManicure(_ manicure: Manicure) {
        manicures.removeAll { $0.id == manicure.id }
        saveManicures()
        updateColors()
    }
    
    func toggleFavorite(_ manicure: Manicure) {
        if let index = manicures.firstIndex(where: { $0.id == manicure.id }) {
            manicures[index].isFavorite.toggle()
            saveManicures()
        }
    }
    
    private func addMasterIfNeeded(_ master: Master) {
        if !masters.contains(where: { $0.name.lowercased() == master.name.lowercased() }) {
            masters.append(master)
            saveMasters()
        }
    }
    
    func createMaster(name: String) -> Master {
        let master = Master(name: name)
        addMasterIfNeeded(master)
        return master
    }
    
    private func updateColors() {
        var colorCounts: [String: Int] = [:]
        
        for manicure in manicures {
            for color in manicure.colors {
                let colorName = color.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                if !colorName.isEmpty {
                    colorCounts[colorName, default: 0] += 1
                }
            }
        }
        
        colors = colorCounts.map { ManicureColor(name: $0.key.capitalized, count: $0.value) }
            .sorted { $0.count > $1.count }
    }
    
    var filteredManicures: [Manicure] {
        if searchText.isEmpty {
            return manicures.sorted { $0.date > $1.date }
        } else {
            return manicures.filter { manicure in
                manicure.designName.localizedCaseInsensitiveContains(searchText) ||
                manicure.master.name.localizedCaseInsensitiveContains(searchText) ||
                manicure.colorsString.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.date > $1.date }
        }
    }
    
    var favoriteManicures: [Manicure] {
        manicures.filter { $0.isFavorite }.sorted { $0.date > $1.date }
    }
    
    func manicuresForColor(_ colorName: String) -> [Manicure] {
        manicures.filter { manicure in
            manicure.colors.contains { color in
                color.lowercased().contains(colorName.lowercased())
            }
        }.sorted { $0.date > $1.date }
    }
    
    func manicuresForMaster(_ master: Master) -> [Manicure] {
        manicures.filter { $0.master.id == master.id }.sorted { $0.date > $1.date }
    }
    
    var mastersWithCounts: [(master: Master, count: Int)] {
        let masterCounts = masters.map { master in
            let count = manicures.filter { $0.master.id == master.id }.count
            return (master: master, count: count)
        }.filter { $0.count > 0 }
        
        return masterCounts.sorted { $0.count > $1.count }
    }
}
