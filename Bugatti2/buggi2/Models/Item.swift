import Foundation

struct Item: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var location: String
    var owner: String
    var notes: String
    var dateCreated: Date
    
    init(name: String, location: String, owner: String, notes: String) {
        self.id = UUID()
        self.name = name
        self.location = location
        self.owner = owner
        self.notes = notes
        self.dateCreated = Date()
    }
}

extension Item {
    static let sampleItems = [
        Item(name: "MacBook Pro", location: "Home Office", owner: "John", notes: "Work laptop"),
        Item(name: "Bicycle", location: "Garage", owner: "Sarah", notes: "Mountain bike for weekend rides"),
        Item(name: "Coffee Machine", location: "Kitchen", owner: "Family", notes: "Espresso maker"),
        Item(name: "Bookshelf", location: "Living Room", owner: "Family", notes: "Oak wood, 5 shelves"),
        Item(name: "Toolbox", location: "Garage", owner: "John", notes: "Hand tools and drill"),
        Item(name: "TV", location: "Living Room", owner: "Family", notes: "55 inch Smart TV"),
        Item(name: "Winter Tires", location: "Garage", owner: "Sarah", notes: "Stored in bags"),
        Item(name: "Vacuum Cleaner", location: "Storage", owner: "Family", notes: "Cordless"),
        Item(name: "Camping Tent", location: "Garage", owner: "John", notes: "4-person tent"),
        Item(name: "Desk Lamp", location: "Home Office", owner: "John", notes: "LED adjustable")
    ]
}
