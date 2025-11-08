import Foundation

struct WishlistItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var country: String?
    var city: String?
    var notes: String
    var isPriority: Bool = false
    var createdAt: Date = Date()
    
    var locationString: String {
        var components: [String] = []
        
        if let country = country, !country.isEmpty {
            components.append(country)
        }
        
        if let city = city, !city.isEmpty {
            components.append(city)
        }
        
        return components.joined(separator: ", ")
    }
    
    var shortNotes: String {
        if notes.count > 80 {
            return String(notes.prefix(80)) + "..."
        }
        return notes
    }
}

