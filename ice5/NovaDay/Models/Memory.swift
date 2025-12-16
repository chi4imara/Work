import Foundation

struct Memory: Identifiable, Codable {
    let id: UUID
    var date: Date
    var title: String
    var description: String
    var mood: String
    var isFavorite: Bool = false
    
    init(id: UUID = UUID(), date: Date = Date(), title: String = "", description: String = "", mood: String = "😊", isFavorite: Bool = false) {
        self.id = id
        self.date = date
        self.title = title
        self.description = description
        self.mood = mood
        self.isFavorite = isFavorite
    }
}

extension Memory {
    static let sampleMemories: [Memory] = [
        Memory(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            title: "Great day at work",
            description: "Had an amazing presentation today. The team loved the new project proposal and we got approval to move forward.",
            mood: "🤩"
        ),
        Memory(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            title: "Coffee with friends",
            description: "Met up with old college friends at our favorite café. We talked for hours about life and shared so many laughs.",
            mood: "😀"
        ),
        Memory(
            date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            title: "Quiet evening",
            description: "Spent the evening reading a good book and listening to rain outside. Sometimes the simple moments are the best.",
            mood: "😐"
        )
    ]
}
