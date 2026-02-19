import Foundation

struct Procedure: Identifiable, Codable {
    let id: UUID
    var type: ProcedureType
    var date: Date
    var product: String
    var note: String
    
    init(type: ProcedureType, date: Date = Date(), product: String = "", note: String = "", id: UUID = UUID()) {
        self.id = id
        self.type = type
        self.date = date
        self.product = product
        self.note = note
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var shortFormattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}
