import Foundation
import SwiftUI
import Combine

class ProjectViewModel: ObservableObject {
    @Published var projects: [Project] = []
    
    private let userDefaults = UserDefaults.standard
    private let projectsKey = "SavedProjects"
    
    init() {
        loadProjects()
    }
    
    func addProject(_ project: Project) {
        projects.append(project)
        saveProjects()
    }
    
    func updateProject(_ project: Project) {
        if let index = projects.firstIndex(where: { $0.id == project.id }) {
            projects[index] = project
            saveProjects()
        }
    }
    
    func deleteProject(_ project: Project) {
        projects.removeAll { $0.id == project.id }
        saveProjects()
    }
    
    func getProjectsByCategory() -> [String: [Project]] {
        Dictionary(grouping: projects, by: { $0.category })
    }
    
    func getCategoriesWithCount() -> [(category: String, count: Int)] {
        let grouped = getProjectsByCategory()
        return grouped.map { (category: $0.key, count: $0.value.count) }
            .sorted { $0.category < $1.category }
    }
    
    func getProject(by id: UUID) -> Project? {
        projects.first { $0.id == id }
    }
    
    private func saveProjects() {
        if let encoded = try? JSONEncoder().encode(projects) {
            userDefaults.set(encoded, forKey: projectsKey)
        }
    }
    
    private func loadProjects() {
        if let data = userDefaults.data(forKey: projectsKey),
           let decoded = try? JSONDecoder().decode([Project].self, from: data) {
            projects = decoded
        }
    }
}
