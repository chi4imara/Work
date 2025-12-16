import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var cosmeticSets: [CosmeticSet] = []
    @Published var products: [Product] = []
    @Published var notes: [Note] = []
    @Published var showOnboarding = true
    @Published var showSplash = true
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "hasSeenOnboarding"
    
    init() {
        loadData()
        checkOnboardingStatus()
    }
    
    func checkOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: onboardingKey)
        showOnboarding = false
    }
    
    func completeSplash() {
        showSplash = false
    }
    
    func addCosmeticSet(_ set: CosmeticSet) {
        cosmeticSets.append(set)
        saveData()
    }
    
    func updateCosmeticSet(_ set: CosmeticSet) {
        if let index = cosmeticSets.firstIndex(where: { $0.id == set.id }) {
            var updatedSet = set
            updatedSet.updateModifiedDate()
            cosmeticSets[index] = updatedSet
            saveData()
        }
    }
    
    func deleteCosmeticSet(_ set: CosmeticSet) {
        cosmeticSets.removeAll { $0.id == set.id }
        saveData()
    }
    
    func filteredSets(filter: SetFilter) -> [CosmeticSet] {
        switch filter {
        case .all:
            return cosmeticSets.sorted { $0.dateModified > $1.dateModified }
        case .ready:
            return cosmeticSets.filter { $0.isReady }.sorted { $0.dateModified > $1.dateModified }
        case .notReady:
            return cosmeticSets.filter { !$0.isReady }.sorted { $0.dateModified > $1.dateModified }
        }
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
        saveData()
    }
    
    func updateProduct(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            saveData()
        }
    }
    
    func deleteProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
        for i in cosmeticSets.indices {
            cosmeticSets[i].products.removeAll { $0.id == product.id }
        }
        saveData()
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveData()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.updateModifiedDate()
            notes[index] = updatedNote
            saveData()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveData()
    }
    
    private func saveData() {
        if let encodedSets = try? JSONEncoder().encode(cosmeticSets) {
            userDefaults.set(encodedSets, forKey: "cosmeticSets")
        }
        
        if let encodedProducts = try? JSONEncoder().encode(products) {
            userDefaults.set(encodedProducts, forKey: "products")
        }
        
        if let encodedNotes = try? JSONEncoder().encode(notes) {
            userDefaults.set(encodedNotes, forKey: "notes")
        }
    }
    
    private func loadData() {
        if let data = userDefaults.data(forKey: "cosmeticSets"),
           let decodedSets = try? JSONDecoder().decode([CosmeticSet].self, from: data) {
            cosmeticSets = decodedSets
        }
        
        if let data = userDefaults.data(forKey: "products"),
           let decodedProducts = try? JSONDecoder().decode([Product].self, from: data) {
            products = decodedProducts
        }
        
        if let data = userDefaults.data(forKey: "notes"),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decodedNotes
        }
    }
}

enum SetFilter: String, CaseIterable {
    case all = "All"
    case ready = "Ready"
    case notReady = "Not Ready"
    
    var displayName: String {
        return self.rawValue
    }
}
