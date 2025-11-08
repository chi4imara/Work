import Foundation

struct Subject: Identifiable, Codable {
    let id: UUID
    var name: String
    var tasks: [Task] = []
    
    var upcomingHomework: Int {
        tasks.filter { $0.type == .homework && $0.dueDate >= Date().startOfDay }.count
    }
    
    var upcomingTests: Int {
        tasks.filter { $0.type == .test && $0.dueDate >= Date().startOfDay }.count
    }
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
