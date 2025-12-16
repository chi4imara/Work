import Foundation
import SwiftUI
import Combine

class ContentIdeasViewModel: ObservableObject {
    @Published var ideas: [ContentIdea] = []
    @Published var searchText = ""
    @Published var selectedFilter: FilterType = .all
    @Published var showingCreateIdea = false
    @Published var selectedIdea: ContentIdea?
    
    private let userDefaults = UserDefaults.standard
    private let ideasKey = "SavedContentIdeas"
    
    init() {
        loadIdeas()
    }
    
    var filteredIdeas: [ContentIdea] {
        var filtered = ideas
        
        switch selectedFilter {
        case .all:
            break
        case .ideas:
            filtered = filtered.filter { $0.status == .idea }
        case .inProgress:
            filtered = filtered.filter { $0.status == .inProgress }
        case .published:
            filtered = filtered.filter { $0.status == .published }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { idea in
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.hashtags.localizedCaseInsensitiveContains(searchText) ||
                idea.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.createdDate > $1.createdDate }
    }
    
    func addIdea(_ idea: ContentIdea) {
        ideas.append(idea)
        saveIdeas()
    }
    
    func updateIdea(_ idea: ContentIdea) {
        if let index = ideas.firstIndex(where: { $0.id == idea.id }) {
            ideas[index] = idea
            saveIdeas()
        }
    }
    
    func deleteIdea(_ idea: ContentIdea) {
        ideas.removeAll { $0.id == idea.id }
        saveIdeas()
    }
    
    func deleteIdea(at indexSet: IndexSet) {
        let filteredIdeas = self.filteredIdeas
        for index in indexSet {
            if index < filteredIdeas.count {
                let ideaToDelete = filteredIdeas[index]
                deleteIdea(ideaToDelete)
            }
        }
    }
    
    func getIdea(by id: UUID) -> ContentIdea? {
        ideas.first { $0.id == id }
    }
    
    private func saveIdeas() {
        if let encoded = try? JSONEncoder().encode(ideas) {
            userDefaults.set(encoded, forKey: ideasKey)
        }
    }
    
    private func loadIdeas() {
        if let data = userDefaults.data(forKey: ideasKey),
           let decoded = try? JSONDecoder().decode([ContentIdea].self, from: data) {
            ideas = decoded
        }
    }
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var searchText = ""
    @Published var showingCreateNote = false
    @Published var selectedNote: Note?
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "SavedNotes"
    
    init() {
        loadNotes()
    }
    
    var filteredNotes: [Note] {
        var filtered = notes
        
        if !searchText.isEmpty {
            filtered = filtered.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { first, second in
            if first.isPinned != second.isPinned {
                return first.isPinned
            }
            return first.createdDate > second.createdDate
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
    
    func deleteNote(at indexSet: IndexSet) {
        let filteredNotes = self.filteredNotes
        for index in indexSet {
            if index < filteredNotes.count {
                let noteToDelete = filteredNotes[index]
                deleteNote(noteToDelete)
            }
        }
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

class CalendarViewModel: ObservableObject {
    @Published var viewMode: CalendarViewMode = .calendar
    @Published var selectedDate: Date = Date()
    
    private var contentIdeasViewModel: ContentIdeasViewModel
    
    init(contentIdeasViewModel: ContentIdeasViewModel) {
        self.contentIdeasViewModel = contentIdeasViewModel
    }
    
    var ideasByDate: [Date: [ContentIdea]] {
        let calendar = Calendar.current
        var grouped: [Date: [ContentIdea]] = [:]
        
        for idea in contentIdeasViewModel.ideas {
            guard let publishDate = idea.publishDate else { continue }
            let dateKey = calendar.startOfDay(for: publishDate)
            
            if grouped[dateKey] == nil {
                grouped[dateKey] = []
            }
            grouped[dateKey]?.append(idea)
        }
        
        return grouped
    }
    
    var sortedDates: [Date] {
        ideasByDate.keys.sorted()
    }
    
    func ideas(for date: Date) -> [ContentIdea] {
        let calendar = Calendar.current
        let dateKey = calendar.startOfDay(for: date)
        return ideasByDate[dateKey] ?? []
    }
    
    func hasIdeas(for date: Date) -> Bool {
        !ideas(for: date).isEmpty
    }
}

class AppStateViewModel: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var showingSplash = true
    @Published var selectedTab = 0
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        checkFirstLaunch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
