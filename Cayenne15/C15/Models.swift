import Foundation

enum RecordType: String, CaseIterable, Identifiable, Codable {
    case wash = "Car Wash"
    case fuel = "Refuel"
    case oilChange = "Oil Change"
    case maintenance = "Maintenance"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .wash:
            return "car.fill"
        case .fuel:
            return "fuelpump.fill"
        case .oilChange:
            return "drop.fill"
        case .maintenance:
            return "wrench.and.screwdriver.fill"
        }
    }
}

struct CarRecord: Identifiable, Codable {
    let id: UUID
    var type: RecordType
    var date: Date
    var mileage: String
    var comment: String
    
    init(type: RecordType, date: Date, mileage: String, comment: String = "") {
        self.id = UUID()
        self.type = type
        self.date = date
        self.mileage = mileage
        self.comment = comment
    }
}

extension CarRecord {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var hasComment: Bool {
        return !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var displayComment: String {
        return hasComment ? comment : "No comment added."
    }
}
