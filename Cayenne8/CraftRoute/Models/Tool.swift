import Foundation

struct Tool: Identifiable, Hashable {
    let id: UUID
    let name: String
    let projectCount: Int
    let projects: [Project]
    
    init(name: String, projects: [Project]) {
        self.id = UUID()
        self.name = name
        self.projects = projects
        self.projectCount = projects.count
    }
    
    static func == (lhs: Tool, rhs: Tool) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

struct Material: Identifiable, Hashable {
    let id: UUID
    let name: String
    let projectCount: Int
    let projects: [Project]
    
    init(name: String, projects: [Project]) {
        self.id = UUID()
        self.name = name
        self.projects = projects
        self.projectCount = projects.count
    }
    
    static func == (lhs: Material, rhs: Material) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
