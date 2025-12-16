import Foundation
import SwiftUI
import Combine

class IdeasViewModel: ObservableObject {
    @Published var ideas: [CraftIdea] = []
    @Published var searchText = ""
    @Published var selectedFilter: IdeaFilter = .all
    @Published var selectedCraftType: CraftType? = nil
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedCraftIdeas"
    
    init() {
        loadIdeas()
    }
    
    var filteredIdeas: [CraftIdea] {
        var filtered = ideas
        
        if !searchText.isEmpty {
            filtered = filtered.filter { idea in
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.description.localizedCaseInsensitiveContains(searchText) ||
                idea.craftType.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        switch selectedFilter {
        case .all:
            break
        case .inProgress:
            filtered = filtered.filter { !$0.isCompleted && $0.completedStepsCount > 0 }
        case .completed:
            filtered = filtered.filter { $0.isCompleted }
        case .notStarted:
            filtered = filtered.filter { !$0.isCompleted && $0.completedStepsCount == 0 }
        }
        
        if let craftType = selectedCraftType {
            filtered = filtered.filter { $0.craftType == craftType }
        }
        
        return filtered.sorted { $0.dateModified > $1.dateModified }
    }
    
    func addIdea(_ idea: CraftIdea) {
        ideas.append(idea)
        saveIdeas()
    }
    
    func updateIdea(_ idea: CraftIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            var updatedIdea = idea
            updatedIdea.dateModified = Date()
            ideas[index] = updatedIdea
            saveIdeas()
        }
    }
    
    func deleteIdea(_ idea: CraftIdea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
    }
    
    func toggleStepCompletion(ideaId: UUID, stepId: UUID) {
        if let ideaIndex = ideas.firstIndex(where: { $0.id == ideaId }),
           let stepIndex = ideas[ideaIndex].steps.firstIndex(where: { $0.id == stepId }) {
            ideas[ideaIndex].steps[stepIndex].isCompleted.toggle()
            ideas[ideaIndex].dateModified = Date()
            
            let allStepsCompleted = ideas[ideaIndex].steps.allSatisfy { $0.isCompleted }
            if allStepsCompleted && !ideas[ideaIndex].steps.isEmpty {
                ideas[ideaIndex].isCompleted = true
            } else if ideas[ideaIndex].isCompleted {
                ideas[ideaIndex].isCompleted = false
            }
            
            saveIdeas()
        }
    }
    
    private func saveIdeas() {
        if let encoded = try? JSONEncoder().encode(ideas) {
            userDefaults.set(encoded, forKey: ideasKey)
        }
    }
    
    private func loadIdeas() {
        if let data = userDefaults.data(forKey: ideasKey),
           let decoded = try? JSONDecoder().decode([CraftIdea].self, from: data) {
            ideas = decoded
        }
    }
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    var sortedNotes: [Note] {
        notes.sorted { $0.dateModified > $1.dateModified }
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.dateModified = Date()
            notes[index] = updatedNote
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
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
    @Published var showingSplash = true
    @Published var selectedTab: TabItem = .ideas
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        checkFirstLaunch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showingSplash = false
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

class MaterialsViewModel: ObservableObject {
    @Published var materials: [Material] = []
    
    private let userDefaults = UserDefaults.standard
    private let materialsKey = "SavedMaterials"
    
    init() {
        loadMaterials()
    }
    
    var sortedMaterials: [Material] {
        materials.sorted { $0.dateModified > $1.dateModified }
    }
    
    var categories: [String] {
        Array(Set(materials.map { $0.category })).filter { !$0.isEmpty }.sorted()
    }
    
    func addMaterial(_ material: Material) {
        materials.append(material)
        saveMaterials()
    }
    
    func updateMaterial(_ material: Material) {
        if let index = materials.firstIndex(where: { $0.id == material.id }) {
            var updatedMaterial = material
            updatedMaterial.dateModified = Date()
            materials[index] = updatedMaterial
            saveMaterials()
        }
    }
    
    func deleteMaterial(_ material: Material) {
        materials.removeAll { $0.id == material.id }
        saveMaterials()
    }
    
    func materialsByCategory(_ category: String) -> [Material] {
        materials.filter { $0.category == category }
    }
    
    private func saveMaterials() {
        if let encoded = try? JSONEncoder().encode(materials) {
            userDefaults.set(encoded, forKey: materialsKey)
        }
    }
    
    private func loadMaterials() {
        if let data = userDefaults.data(forKey: materialsKey),
           let decoded = try? JSONDecoder().decode([Material].self, from: data) {
            materials = decoded
        }
    }
}

class InspirationViewModel: ObservableObject {
    @Published var inspirations: [Inspiration] = []
    @Published var searchText = ""
    
    private let userDefaults = UserDefaults.standard
    private let inspirationsKey = "SavedInspirations"
    
    init() {
        loadInspirations()
    }
    
    var filteredInspirations: [Inspiration] {
        var filtered = inspirations
        
        if !searchText.isEmpty {
            filtered = filtered.filter { inspiration in
                inspiration.title.localizedCaseInsensitiveContains(searchText) ||
                inspiration.description.localizedCaseInsensitiveContains(searchText) ||
                inspiration.tags.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.dateModified > $1.dateModified }
    }
    
    var allTags: [String] {
        Array(Set(inspirations.flatMap { $0.tags })).sorted()
    }
    
    func addInspiration(_ inspiration: Inspiration) {
        inspirations.append(inspiration)
        saveInspirations()
    }
    
    func updateInspiration(_ inspiration: Inspiration) {
        if let index = inspirations.firstIndex(where: { $0.id == inspiration.id }) {
            var updatedInspiration = inspiration
            updatedInspiration.dateModified = Date()
            inspirations[index] = updatedInspiration
            saveInspirations()
        }
    }
    
    func deleteInspiration(_ inspiration: Inspiration) {
        inspirations.removeAll { $0.id == inspiration.id }
        saveInspirations()
    }
    
    private func saveInspirations() {
        if let encoded = try? JSONEncoder().encode(inspirations) {
            userDefaults.set(encoded, forKey: inspirationsKey)
        }
    }
    
    private func loadInspirations() {
        if let data = userDefaults.data(forKey: inspirationsKey),
           let decoded = try? JSONDecoder().decode([Inspiration].self, from: data) {
            inspirations = decoded
        }
    }
}
