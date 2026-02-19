import Foundation
import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var notes: [Note] = []
    @Published var selectedDate: TaskDate = .today
    @Published var showingOnboarding: Bool = true
    
    private let tasksKey = "SavedTasks"
    private let notesKey = "SavedNotes"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadTasks()
        loadNotes()
        checkOnboardingStatus()
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func tasksForDate(_ date: TaskDate) -> [Task] {
        return tasks.filter { $0.date == date }
    }
    
    func tasksForCategory(_ category: TaskCategory) -> [Task] {
        return tasks.filter { $0.category == category }
    }
    
    func completedTasks() -> [Task] {
        return tasks.filter { $0.isCompleted }
    }
    
    func incompleteTasks() -> [Task] {
        return tasks.filter { !$0.isCompleted }
    }
    
    func taskCountForCategory(_ category: TaskCategory) -> Int {
        return tasksForCategory(category).count
    }
    
    func getTask(byId id: UUID) -> Task? {
        return tasks.first { $0.id == id }
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
    
    func completeOnboarding() {
        showingOnboarding = false
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
    
    private func checkOnboardingStatus() {
        showingOnboarding = !UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: tasksKey),
           let decodedTasks = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decodedTasks
        }
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: notesKey)
        }
    }
    
    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: notesKey),
           let decodedNotes = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decodedNotes
        }
    }
}
