import Foundation
import SwiftUI
import Combine

class SubjectStore: ObservableObject {
    @Published var subjects: [Subject] = []
    
    private let userDefaults = UserDefaults.standard
    private let subjectsKey = "SavedSubjects"
    
    init() {
        loadSubjects()
    }
    
    func addSubject(_ subject: Subject) {
        subjects.append(subject)
        subjects.sort { $0.name < $1.name }
        saveSubjects()
        objectWillChange.send()
    }
    
    func updateSubject(_ subject: Subject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index] = subject
            subjects.sort { $0.name < $1.name }
            saveSubjects()
            objectWillChange.send()
        }
    }
    
    func deleteSubject(_ subject: Subject) {
        subjects.removeAll { $0.id == subject.id }
        saveSubjects()
        objectWillChange.send()
    }
    
    func addTask(_ task: Task) {
        if let index = subjects.firstIndex(where: { $0.id == task.subjectId }) {
            subjects[index].tasks.append(task)
            subjects[index].tasks.sort { $0.dueDate < $1.dueDate }
            saveSubjects()
            
            objectWillChange.send()
        }
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let subjectIndex = subjects.firstIndex(where: { $0.id == task.subjectId }),
           let taskIndex = subjects[subjectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            subjects[subjectIndex].tasks[taskIndex].isCompleted.toggle()
            saveSubjects()
            objectWillChange.send()
        }
    }
    
    func updateTask(_ task: Task) {
        if let subjectIndex = subjects.firstIndex(where: { $0.id == task.subjectId }),
           let taskIndex = subjects[subjectIndex].tasks.firstIndex(where: { $0.id == task.id }) {
            subjects[subjectIndex].tasks[taskIndex] = task
            subjects[subjectIndex].tasks.sort { $0.dueDate < $1.dueDate }
            saveSubjects()
            objectWillChange.send()
        }
    }
    
    func getAllTasks() -> [Task] {
        return subjects.flatMap { $0.tasks }
    }
    
    func getTasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return getAllTasks().filter { task in
            calendar.isDate(task.dueDate, inSameDayAs: date)
        }
    }
    
    func getTotalSubjects() -> Int {
        return subjects.count
    }
    
    func getTotalTasks() -> Int {
        return getAllTasks().count
    }
    
    func getCompletedTasks() -> Int {
        return getAllTasks().filter { $0.isCompleted }.count
    }
    
    func getUpcomingTasks() -> Int {
        return getAllTasks().filter { !$0.isCompleted }.count
    }
    
    func getOverdueTasks() -> Int {
        let today = Date().startOfDay
        return getAllTasks().filter { !$0.isCompleted && $0.dueDate < today }.count
    }
    
    func getTasksByType() -> [TaskType: Int] {
        let allTasks = getAllTasks()
        var counts: [TaskType: Int] = [:]
        
        for task in allTasks {
            counts[task.type, default: 0] += 1
        }
        
        return counts
    }
    
    func getTasksBySubject() -> [(Subject, Int)] {
        return subjects.map { subject in
            (subject, subject.tasks.count)
        }.sorted { $0.1 > $1.1 }
    }
    
    func getTasksForLast7Days() -> [Task] {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: today) ?? today
        
        return getAllTasks().filter { task in
            task.dueDate >= sevenDaysAgo && task.dueDate <= today
        }
    }
    
    func getTasksForNext7Days() -> [Task] {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let sevenDaysFromNow = calendar.date(byAdding: .day, value: 7, to: today) ?? today
        
        return getAllTasks().filter { task in
            task.dueDate >= today && task.dueDate <= sevenDaysFromNow
        }
    }
    
    func getCompletedTasksForLast7Days() -> [Task] {
        return getTasksForLast7Days().filter { $0.isCompleted }
    }
    
    func getPendingTasksForNext7Days() -> [Task] {
        return getTasksForNext7Days().filter { !$0.isCompleted }
    }
    
    private func saveSubjects() {
        if let encoded = try? JSONEncoder().encode(subjects) {
            userDefaults.set(encoded, forKey: subjectsKey)
        }
    }
    
    private func loadSubjects() {
        if let data = userDefaults.data(forKey: subjectsKey),
           let decoded = try? JSONDecoder().decode([Subject].self, from: data) {
            subjects = decoded.sorted { $0.name < $1.name }
        }
    }
}
