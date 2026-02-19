import Foundation
import SwiftUI
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var categories: [Category] = Category.defaultCategories
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All Categories"
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    private let categoriesKey = "SavedCategories"
    
    init() {
        loadData()
    }
    
    func saveData() {
        if let notesData = try? JSONEncoder().encode(notes) {
            userDefaults.set(notesData, forKey: notesKey)
        }
        if let categoriesData = try? JSONEncoder().encode(categories) {
            userDefaults.set(categoriesData, forKey: categoriesKey)
        }
    }
    
    func loadData() {
        if let notesData = userDefaults.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: notesData) {
            notes = decodedNotes
        }
        
        if let categoriesData = userDefaults.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories = decodedCategories
        }
        
        updateCategoryCounts()
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        addCategoryIfNeeded(note.category)
        updateCategoryCounts()
        saveData()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            addCategoryIfNeeded(note.category)
            updateCategoryCounts()
            saveData()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        updateCategoryCounts()
        saveData()
    }
    
    func toggleFavorite(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isFavorite.toggle()
            saveData()
        }
    }
    
    func addCategoryIfNeeded(_ categoryName: String) {
        if !categories.contains(where: { $0.name == categoryName }) {
            categories.append(Category(name: categoryName))
        }
    }
    
    func updateCategoryCounts() {
        for i in 0..<categories.count {
            categories[i].notesCount = notes.filter { $0.category == categories[i].name }.count
        }
    }
    
    var filteredNotes: [Note] {
        var filtered = notes
        
        if selectedCategory != "All Categories" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered.sorted { $0.createdAt > $1.createdAt }
    }
    
    var favoriteNotes: [Note] {
        return notes.filter { $0.isFavorite }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func notesForCategory(_ categoryName: String) -> [Note] {
        return notes.filter { $0.category == categoryName }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getNote(by id: UUID) -> Note? {
        return notes.first { $0.id == id }
    }
    
    var availableCategories: [String] {
        return ["All Categories"] + categories.map { $0.name }
    }
}
