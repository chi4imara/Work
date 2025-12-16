import Foundation
import SwiftUI
import Combine

class MakeupLooksViewModel: ObservableObject {
    @Published var looks: [MakeupLook] = []
    @Published var searchText = ""
    @Published var selectedCategory: MakeupCategory? = nil
    
    private let userDefaults = UserDefaults.standard
    private let looksKey = "SavedMakeupLooks"
    
    init() {
        loadLooks()
    }
    
    var filteredLooks: [MakeupLook] {
        var filtered = looks
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { look in
                look.name.localizedCaseInsensitiveContains(searchText) ||
                look.mainShades.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func addLook(_ look: MakeupLook) {
        looks.append(look)
        saveLooks()
    }
    
    func updateLook(_ look: MakeupLook) {
        if let index = looks.firstIndex(where: { $0.id == look.id }) {
            looks[index] = look
            saveLooks()
        }
    }
    
    func deleteLook(_ look: MakeupLook) {
        looks.removeAll { $0.id == look.id }
        saveLooks()
    }
    
    func getLook(by id: UUID) -> MakeupLook? {
        looks.first { $0.id == id }
    }
    
    private func saveLooks() {
        if let encoded = try? JSONEncoder().encode(looks) {
            userDefaults.set(encoded, forKey: looksKey)
        }
    }
    
    private func loadLooks() {
        if let data = userDefaults.data(forKey: looksKey),
           let decoded = try? JSONDecoder().decode([MakeupLook].self, from: data) {
            looks = decoded
        }
    }
}

class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText = ""
    
    private let userDefaults = UserDefaults.standard
    private let productsKey = "SavedProducts"
    
    init() {
        loadProducts()
    }
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products.sorted { $0.dateAdded > $1.dateAdded }
        } else {
            return products.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.dateAdded > $1.dateAdded }
        }
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
        saveProducts()
    }
    
    func updateProduct(_ product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index] = product
            saveProducts()
        }
    }
    
    func deleteProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
        saveProducts()
    }
    
    func getProduct(by id: UUID) -> Product? {
        products.first { $0.id == id }
    }
    
    private func saveProducts() {
        if let encoded = try? JSONEncoder().encode(products) {
            userDefaults.set(encoded, forKey: productsKey)
        }
    }
    
    private func loadProducts() {
        if let data = userDefaults.data(forKey: productsKey),
           let decoded = try? JSONDecoder().decode([Product].self, from: data) {
            products = decoded
        }
    }
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText = ""
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    var filteredNotes: [Note] {
        let filtered = searchText.isEmpty ? notes : notes.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.content.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { first, second in
            if first.isPinned != second.isPinned {
                return first.isPinned
            }
            return first.dateCreated > second.dateCreated
        }
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
    
    func togglePin(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isPinned.toggle()
            saveNotes()
        }
    }
    
    func getNote(by id: UUID) -> Note? {
        notes.first { $0.id == id }
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

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var selectedTab: TabItem = .looks
    @Published var isLoading = true
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        checkFirstLaunch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isLoading = false
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        isFirstLaunch = false
    }
}
