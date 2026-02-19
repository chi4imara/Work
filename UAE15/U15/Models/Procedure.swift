import Foundation

struct Procedure: Codable, Identifiable {
    let id: UUID
    let date: Date
    let barberName: String
    let services: [Service]
    let comment: String
    let createdAt: Date
    
    init(date: Date, barberName: String, services: [Service], comment: String = "") {
        self.id = UUID()
        self.date = date
        self.barberName = barberName
        self.services = services
        self.comment = comment
        self.createdAt = Date()
    }
    
    var servicesDisplayText: String {
        return services.map { $0.displayName }.joined(separator: ", ")
    }
    
    var categories: Set<ServiceCategory> {
        return Set(services.map { $0.type.category })
    }
    
    func matchesSearch(_ searchText: String) -> Bool {
        if searchText.isEmpty { return true }
        
        let lowercasedSearch = searchText.lowercased()
        return barberName.lowercased().contains(lowercasedSearch) ||
               servicesDisplayText.lowercased().contains(lowercasedSearch) ||
               comment.lowercased().contains(lowercasedSearch)
    }
    
    func matchesCategory(_ category: ServiceCategory) -> Bool {
        if category == .all { return true }
        return categories.contains(category)
    }
}
