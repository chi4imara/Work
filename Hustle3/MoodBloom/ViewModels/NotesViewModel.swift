import Foundation
import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var sortOrder: SortOrder = .newestFirst
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "Notes"
    private let sortOrderKey = "NotesSortOrder"
    
    enum SortOrder: String, CaseIterable {
        case newestFirst = "newest"
        case oldestFirst = "oldest"
        
        var description: String {
            switch self {
            case .newestFirst: return "Newest First"
            case .oldestFirst: return "Oldest First"
            }
        }
    }
    
    init() {
        loadNotes()
        loadSortOrder()
    }
    
    func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let notes = try? JSONDecoder().decode([Note].self, from: data) {
            self.notes = notes
            applySorting()
        }
    }
    
    func loadSortOrder() {
        if let sortOrderString = userDefaults.string(forKey: sortOrderKey),
           let sortOrder = SortOrder(rawValue: sortOrderString) {
            self.sortOrder = sortOrder
        }
    }
    
    func saveSortOrder() {
        userDefaults.set(sortOrder.rawValue, forKey: sortOrderKey)
    }
    
    func saveNotes() {
        if let data = try? JSONEncoder().encode(notes) {
            userDefaults.set(data, forKey: notesKey)
        }
    }
    
    func addNote(title: String, content: String) {
        let note = Note(title: title, content: content)
        notes.append(note)
        applySorting()
        saveNotes()
    }
    
    func updateNote(_ note: Note, title: String, content: String) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].update(title: title, content: content)
            applySorting()
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func getNote(by id: UUID) -> Note? {
        return notes.first { $0.id == id }
    }
    
    func toggleSortOrder() {
        sortOrder = sortOrder == .newestFirst ? .oldestFirst : .newestFirst
        applySorting()
        saveSortOrder()
    }
    
    private func applySorting() {
        switch sortOrder {
        case .newestFirst:
            notes.sort { $0.createdAt > $1.createdAt }
        case .oldestFirst:
            notes.sort { $0.createdAt < $1.createdAt }
        }
    }
}
