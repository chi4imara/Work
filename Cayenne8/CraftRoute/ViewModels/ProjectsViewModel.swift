import Foundation
import SwiftUI
import Combine

class ProjectsViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var selectedCategory: ProjectCategory? = nil
    @Published var isLoading = false
    
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
    
    func getProject(by id: UUID) -> Project? {
        return projects.first { $0.id == id }
    }
    
    func getProjects(byToolName toolName: String) -> [Project] {
        return projects.filter { project in
            project.tools.contains { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == toolName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        }
    }
    
    func getProjects(byMaterialName materialName: String) -> [Project] {
        return projects.filter { project in
            project.materials.contains { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == materialName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        }
    }
        
    var filteredProjects: [Project] {
        if let selectedCategory = selectedCategory {
            return projects.filter { $0.category == selectedCategory }
        }
        return projects
    }
    
    func setFilter(_ category: ProjectCategory?) {
        selectedCategory = category
    }
        
    var allTools: [Tool] {
        var toolDict: [String: [Project]] = [:]
        
        for project in projects {
            for tool in project.tools {
                let trimmedTool = tool.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedTool.isEmpty {
                    if toolDict[trimmedTool] == nil {
                        toolDict[trimmedTool] = []
                    }
                    toolDict[trimmedTool]?.append(project)
                }
            }
        }
        
        return toolDict.map { Tool(name: $0.key, projects: $0.value) }
            .sorted { $0.projectCount > $1.projectCount }
    }
    
    var allMaterials: [Material] {
        var materialDict: [String: [Project]] = [:]
        
        for project in projects {
            for material in project.materials {
                let trimmedMaterial = material.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedMaterial.isEmpty {
                    if materialDict[trimmedMaterial] == nil {
                        materialDict[trimmedMaterial] = []
                    }
                    materialDict[trimmedMaterial]?.append(project)
                }
            }
        }
        
        return materialDict.map { Material(name: $0.key, projects: $0.value) }
            .sorted { $0.projectCount > $1.projectCount }
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
