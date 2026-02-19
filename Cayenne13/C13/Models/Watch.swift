import Foundation

struct Watch: Identifiable, Codable {
    let id: UUID
    var name: String
    var purchaseDate: Date
    var style: WatchStyle
    var condition: WatchCondition
    var comment: String
    var wearingDays: [WearingDay]
    
    init(name: String, purchaseDate: Date, style: WatchStyle, condition: WatchCondition, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.purchaseDate = purchaseDate
        self.style = style
        self.condition = condition
        self.comment = comment
        self.wearingDays = []
    }
}

enum WatchStyle: String, CaseIterable, Codable {
    case classic = "Classic"
    case sport = "Sport"
    case casual = "Casual"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

enum WatchCondition: String, CaseIterable, Codable {
    case new = "New"
    case excellent = "Excellent"
    case good = "Good"
    case wornSigns = "Worn Signs"
    
    var displayName: String {
        return self.rawValue
    }
}

struct WearingDay: Identifiable, Codable {
    let id: UUID
    let date: Date
    let watchId: UUID
    
    init(date: Date, watchId: UUID) {
        self.id = UUID()
        self.date = date
        self.watchId = watchId
    }
}
