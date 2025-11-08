import Foundation

struct Game: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: GameCategory
    var description: String
    var sections: [GameSection]
    var isFavorite: Bool
    var dateCreated: Date
    var dateModified: Date
    
    init(name: String, category: GameCategory, description: String = "") {
        self.name = name
        self.category = category
        self.description = description
        self.sections = []
        self.isFavorite = false
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    var sectionCount: Int {
        return sections.count
    }
    
    mutating func addSection(_ section: GameSection) {
        sections.append(section)
        dateModified = Date()
    }
    
    mutating func removeSection(at index: Int) {
        guard index < sections.count else { return }
        sections.remove(at: index)
        dateModified = Date()
    }
    
    mutating func updateSection(at index: Int, with section: GameSection) {
        guard index < sections.count else { return }
        sections[index] = section
        dateModified = Date()
    }
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
        dateModified = Date()
    }
    
    mutating func updateInfo(name: String, category: GameCategory, description: String) {
        self.name = name
        self.category = category
        self.description = description
        self.dateModified = Date()
    }
}
