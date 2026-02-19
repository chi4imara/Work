import Foundation
import SwiftUI
import Combine

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    init() {
        loadNotes()
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaults.savedNotes)
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: Constants.UserDefaults.savedNotes),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded.sorted { $0.createdDate > $1.createdDate }
        }
    }
}
