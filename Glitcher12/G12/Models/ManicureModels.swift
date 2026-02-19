import Foundation

struct Manicure: Identifiable, Codable, Equatable {
    let id: UUID
    var designName: String
    var colors: [String]
    var master: Master
    var date: Date
    var notes: String
    var isFavorite: Bool = false
    
    init(designName: String, colors: [String], master: Master, date: Date, notes: String, isFavorite: Bool = false) {
        self.id = UUID()
        self.designName = designName
        self.colors = colors
        self.master = master
        self.date = date
        self.notes = notes
        self.isFavorite = isFavorite
    }
    
    var colorsString: String {
        colors.joined(separator: ", ")
    }
    
    var dateString: String {
        date.manicureDateString
    }
    
    static func == (lhs: Manicure, rhs: Manicure) -> Bool {
        lhs.id == rhs.id
    }
}

struct Master: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    static func == (lhs: Master, rhs: Master) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ManicureColor: Identifiable, Codable {
    let id: UUID
    var name: String
    var count: Int = 0
    
    init(name: String, count: Int = 0) {
        self.id = UUID()
        self.name = name
        self.count = count
    }
    
    var countString: String {
        "\(count) manicure\(count == 1 ? "" : "s")"
    }
}

extension Manicure {
    static let sampleData: [Manicure] = [
        Manicure(
            designName: "French with Gold Stripe",
            colors: ["white", "gold"],
            master: Master(name: "Marina"),
            date: Date().addingTimeInterval(-86400 * 7),
            notes: "Lasted 3 weeks, very durable"
        ),
        Manicure(
            designName: "Nude Gradient",
            colors: ["nude", "pink", "white"],
            master: Master(name: "Anna"),
            date: Date().addingTimeInterval(-86400 * 14),
            notes: "Perfect for office"
        ),
        Manicure(
            designName: "Dark Blue with Glitter",
            colors: ["dark blue", "silver glitter"],
            master: Master(name: "Marina"),
            date: Date().addingTimeInterval(-86400 * 21),
            notes: "Evening look"
        )
    ]
}

extension Master {
    static let sampleData: [Master] = [
        Master(name: "Marina"),
        Master(name: "Anna"),
        Master(name: "Elena"),
        Master(name: "Olga")
    ]
}
