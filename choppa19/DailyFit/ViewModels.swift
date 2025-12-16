import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var outfits: [Outfit] = []
    @Published var notes: [Note] = []
    @Published var weekPlan = WeekPlan()
    
    private let outfitsKey = "SavedOutfits"
    private let notesKey = "SavedNotes"
    private let weekPlanKey = "WeekPlan"
    
    private init() {
        loadData()
    }
    
    private func loadData() {
        loadOutfits()
        loadNotes()
        loadWeekPlan()
    }
    
    private func loadOutfits() {
        if let data = UserDefaults.standard.data(forKey: outfitsKey),
           let decodedOutfits = try? JSONDecoder().decode([Outfit].self, from: data) {
            self.outfits = decodedOutfits
        }
    }
    
    private func saveOutfits() {
        if let encoded = try? JSONEncoder().encode(outfits) {
            UserDefaults.standard.set(encoded, forKey: outfitsKey)
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            self.notes = decodedNotes
        }
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    private func loadWeekPlan() {
        if let data = UserDefaults.standard.data(forKey: weekPlanKey),
           let decodedPlan = try? JSONDecoder().decode(WeekPlan.self, from: data) {
            self.weekPlan = decodedPlan
        }
    }
    
    private func saveWeekPlan() {
        if let encoded = try? JSONEncoder().encode(weekPlan) {
            UserDefaults.standard.set(encoded, forKey: weekPlanKey)
        }
    }
    
    func addOutfit(_ outfit: Outfit) {
        outfits.append(outfit)
        saveOutfits()
    }
    
    func updateOutfit(_ outfit: Outfit) {
        if let index = outfits.firstIndex(where: { $0.id == outfit.id }) {
            outfits[index] = outfit
            saveOutfits()
        }
    }
    
    func deleteOutfit(_ outfit: Outfit) {
        outfits.removeAll { $0.id == outfit.id }
        for day in WeekDay.allCases {
            if weekPlan.getOutfit(for: day) == outfit.id {
                weekPlan.setOutfit(for: day, outfitId: nil)
            }
        }
        saveOutfits()
        saveWeekPlan()
    }
    
    func getOutfit(by id: UUID) -> Outfit? {
        return outfits.first { $0.id == id }
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
    
    func setOutfitForDay(_ day: WeekDay, outfitId: UUID?) {
        weekPlan.setOutfit(for: day, outfitId: outfitId)
        saveWeekPlan()
    }
    
    func clearWeekPlan() {
        weekPlan.clearAll()
        saveWeekPlan()
    }
}

class OutfitListViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedFilter: OutfitFilter = .all
    @Published var selectedSeason: Season?
    @Published var selectedMood: Mood?
    
    private let dataManager = DataManager.shared
    
    var filteredOutfits: [Outfit] {
        var filtered = dataManager.outfits
        
        if !searchText.isEmpty {
            filtered = filtered.filter { outfit in
                outfit.name.localizedCaseInsensitiveContains(searchText) ||
                outfit.comment.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedFilter {
        case .all:
            break
        case .favorites:
            filtered = filtered.filter { $0.isFavorite }
        case .season:
            if let season = selectedSeason {
                filtered = filtered.filter { $0.season == season }
            }
        case .mood:
            if let mood = selectedMood {
                filtered = filtered.filter { $0.mood == mood }
            }
        }
        
        return filtered.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    func deleteOutfit(_ outfit: Outfit) {
        dataManager.deleteOutfit(outfit)
    }
    
    func toggleFavorite(_ outfit: Outfit) {
        var updatedOutfit = outfit
        updatedOutfit.isFavorite.toggle()
        dataManager.updateOutfit(updatedOutfit)
    }
}

class AddEditOutfitViewModel: ObservableObject {
    @Published var name = ""
    @Published var selectedSeason: Season = .spring
    @Published var selectedMood: Mood = .casual
    @Published var selectedSituation: Situation = .work
    @Published var comment = ""
    @Published var isFavorite = false
    
    private let dataManager = DataManager.shared
    private var editingOutfit: Outfit?
    
    var isEditing: Bool {
        return editingOutfit != nil
    }
    
    var canSave: Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func setEditingOutfit(_ outfit: Outfit) {
        self.editingOutfit = outfit
        self.name = outfit.name
        self.selectedSeason = outfit.season
        self.selectedMood = outfit.mood
        self.selectedSituation = outfit.situation
        self.comment = outfit.comment
        self.isFavorite = outfit.isFavorite
    }
    
    func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        if let existingOutfit = editingOutfit {
            var updatedOutfit = existingOutfit
            updatedOutfit.name = trimmedName
            updatedOutfit.season = selectedSeason
            updatedOutfit.mood = selectedMood
            updatedOutfit.situation = selectedSituation
            updatedOutfit.comment = comment
            updatedOutfit.isFavorite = isFavorite
            dataManager.updateOutfit(updatedOutfit)
        } else {
            let newOutfit = Outfit(
                name: trimmedName,
                season: selectedSeason,
                mood: selectedMood,
                situation: selectedSituation,
                comment: comment,
                isFavorite: isFavorite
            )
            dataManager.addOutfit(newOutfit)
        }
    }
    
    func reset() {
        editingOutfit = nil
        name = ""
        selectedSeason = .spring
        selectedMood = .casual
        selectedSituation = .work
        comment = ""
        isFavorite = false
    }
}

class WeekPlanViewModel: ObservableObject {
    @Published var weekPlan: WeekPlan
    @Published var outfits: [Outfit]
    
    private let dataManager = DataManager.shared
    
    init() {
        self.weekPlan = dataManager.weekPlan
        self.outfits = dataManager.outfits
        
        dataManager.$weekPlan
            .assign(to: &$weekPlan)
        
        dataManager.$outfits
            .assign(to: &$outfits)
    }
    
    func getOutfitName(for day: WeekDay) -> String? {
        guard let outfitId = weekPlan.getOutfit(for: day),
              let outfit = dataManager.getOutfit(by: outfitId) else {
            return nil
        }
        return outfit.name
    }
    
    func getOutfit(for day: WeekDay) -> Outfit? {
        guard let outfitId = weekPlan.getOutfit(for: day) else {
            return nil
        }
        return dataManager.getOutfit(by: outfitId)
    }
    
    func setOutfit(for day: WeekDay, outfit: Outfit?) {
        dataManager.setOutfitForDay(day, outfitId: outfit?.id)
    }
    
    func clearPlan() {
        dataManager.clearWeekPlan()
    }
}

class NotesViewModel: ObservableObject {
    private let dataManager = DataManager.shared
    
    var notes: [Note] {
        return dataManager.notes.sorted { $0.dateModified > $1.dateModified }
    }
    
    func addNote(_ note: Note) {
        dataManager.addNote(note)
    }
    
    func updateNote(_ note: Note) {
        dataManager.updateNote(note)
    }
    
    func deleteNote(_ note: Note) {
        dataManager.deleteNote(note)
    }
}

class AddEditNoteViewModel: ObservableObject {
    @Published var title = ""
    @Published var content = ""
    
    private let dataManager = DataManager.shared
    private var editingNote: Note?
    
    var isEditing: Bool {
        return editingNote != nil
    }
    
    var canSave: Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func setEditingNote(_ note: Note) {
        self.editingNote = note
        self.title = note.title
        self.content = note.content
    }
    
    func save() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        if let existingNote = editingNote {
            var updatedNote = existingNote
            updatedNote.update(title: trimmedTitle, content: content)
            dataManager.updateNote(updatedNote)
        } else {
            let newNote = Note(title: trimmedTitle, content: content)
            dataManager.addNote(newNote)
        }
    }
    
    func reset() {
        editingNote = nil
        title = ""
        content = ""
    }
}
