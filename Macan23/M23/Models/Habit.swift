import Foundation

struct Habit: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: HabitCategory
    var time: String
    var description: String
    var comment: String
    var createdAt: Date
    
    init(name: String, category: HabitCategory, time: String, description: String, comment: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.time = time
        self.description = description
        self.comment = comment
        self.createdAt = Date()
    }
}

enum HabitCategory: String, CaseIterable, Codable {
    case morning = "Morning"
    case day = "Day"
    case evening = "Evening"
    case weekend = "Weekend"
    
    var displayName: String {
        return self.rawValue
    }
}

struct HabitFilter {
    var selectedCategories: Set<HabitCategory> = []
    var timeFrom: String = ""
    var timeTo: String = ""
    var searchText: String = ""
    
    var isActive: Bool {
        return !selectedCategories.isEmpty || !timeFrom.isEmpty || !timeTo.isEmpty || !searchText.isEmpty
    }
    
    mutating func reset() {
        selectedCategories.removeAll()
        timeFrom = ""
        timeTo = ""
        searchText = ""
    }
}
