import Foundation

enum TaskCategory: String, CaseIterable, Identifiable {
    case singing = "Singing"
    case dancing = "Dancing"
    case animals = "Animals"
    case funny = "Funny"
    case other = "Other"
    
    var id: String {
        return self.rawValue
    }
    
    var displayName: String {
        return self.rawValue
    }
}
