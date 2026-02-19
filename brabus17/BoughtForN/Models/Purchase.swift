import Foundation

struct Purchase: Identifiable, Codable {
    let id: UUID
    var date: Date
    var whatBought: String
    var whereBought: String
    var whyBought: String
    
    init(date: Date = Date(), whatBought: String, whereBought: String = "", whyBought: String = "") {
        self.id = UUID()
        self.date = date
        self.whatBought = whatBought
        self.whereBought = whereBought
        self.whyBought = whyBought
    }
    
    init(id: UUID, date: Date, whatBought: String, whereBought: String = "", whyBought: String = "") {
        self.id = id
        self.date = date
        self.whatBought = whatBought
        self.whereBought = whereBought
        self.whyBought = whyBought
    }
}

extension Purchase {
    static let sampleData: [Purchase] = [
        Purchase(
            date: Date().addingTimeInterval(-86400 * 2),
            whatBought: "Coffee beans",
            whereBought: "Local coffee shop",
            whyBought: "Running low on morning coffee"
        ),
        Purchase(
            date: Date().addingTimeInterval(-86400),
            whatBought: "New book",
            whereBought: "Bookstore downtown",
            whyBought: "Wanted to learn about SwiftUI"
        ),
        Purchase(
            date: Date(),
            whatBought: "Groceries",
            whereBought: "Supermarket",
            whyBought: "Weekly shopping"
        )
    ]
}
