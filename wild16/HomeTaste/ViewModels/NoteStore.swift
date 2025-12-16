import Foundation
import SwiftUI
import Combine

class NoteStore: ObservableObject {
    @Published var notes: [Note] = []
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    var sortedNotes: [Note] {
        return notes.sorted { $0.dateCreated > $1.dateCreated }
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
    
    func getNote(by id: UUID) -> Note? {
        return notes.first { $0.id == id }
    }
    
    func getNotesForRecipe(recipeId: UUID) -> [Note] {
        return notes.filter { $0.recipeId == recipeId }
            .sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func updateRecipeName(recipeId: UUID, newName: String) {
        for index in notes.indices {
            if notes[index].recipeId == recipeId {
                notes[index].recipeName = newName
            }
        }
        saveNotes()
    }
    
    func removeRecipeLink(recipeId: UUID) {
        for index in notes.indices {
            if notes[index].recipeId == recipeId {
                notes[index].recipeName = "recipe deleted"
            }
        }
        saveNotes()
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            userDefaults.set(encoded, forKey: notesKey)
        }
    }
    
    private func loadNotes() {
        if let data = userDefaults.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decodedNotes
        }
    }
}
