import Foundation

enum TransactionType: String, CaseIterable, Codable {
    case purchase = "Purchase"
    case sale = "Sale"
    case trade = "Trade"
    case other = "Other"
}

struct Transaction: Identifiable, Codable {
    var id = UUID()
    var type: TransactionType
    var itemId: UUID?
    var itemName: String
    var amount: Double
    var counterparty: String
    var notes: String
    var date: Date
    
    init(type: TransactionType = .purchase, itemId: UUID? = nil, itemName: String = "", amount: Double = 0, counterparty: String = "", notes: String = "") {
        self.type = type
        self.itemId = itemId
        self.itemName = itemName
        self.amount = amount
        self.counterparty = counterparty
        self.notes = notes
        self.date = Date()
    }
}
