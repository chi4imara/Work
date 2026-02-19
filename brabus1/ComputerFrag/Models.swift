import Foundation

enum DeviceCategory: String, CaseIterable, Codable {
    case pc = "PC"
    case console = "Console"
    case peripherals = "Peripherals"
    case accessories = "Accessories"
    
    var subcategories: [String] {
        switch self {
        case .pc:
            return ["Desktop", "Laptop", "Mini PC", "Workstation"]
        case .console:
            return ["PlayStation", "Xbox", "Nintendo", "Steam Deck"]
        case .peripherals:
            return ["Monitor", "Keyboard", "Mouse", "Headset", "Speakers"]
        case .accessories:
            return ["Cable", "Stand", "Case", "Cooling", "Storage"]
        }
    }
}

enum ImprovementStatus: String, CaseIterable, Codable {
    case planned = "Planned"
    case completed = "Completed"
    
    var color: String {
        switch self {
        case .planned:
            return "orange"
        case .completed:
            return "green"
        }
    }
}

struct Device: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: DeviceCategory
    var subcategory: String
    var description: String
    var improvements: [Improvement] = []
    var createdAt: Date = Date()
    
    var improvementsSummary: String {
        let plannedCount = improvements.filter { $0.status == .planned }.count
        let completedCount = improvements.filter { $0.status == .completed }.count
        
        if improvements.isEmpty {
            return "No improvements"
        } else if plannedCount > 0 && completedCount > 0 {
            return "\(plannedCount) planned, \(completedCount) completed"
        } else if plannedCount > 0 {
            return "\(plannedCount) improvement\(plannedCount == 1 ? "" : "s") planned"
        } else {
            return "\(completedCount) improvement\(completedCount == 1 ? "" : "s") completed"
        }
    }
}

struct Improvement: Identifiable, Codable {
    let id = UUID()
    var name: String
    var status: ImprovementStatus
    var description: String
    var deviceId: UUID
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    mutating func updateStatus(_ newStatus: ImprovementStatus) {
        status = newStatus
        updatedAt = Date()
    }
}

extension Device {
    static let sampleDevices: [Device] = [
        Device(
            name: "Gaming PC",
            category: .pc,
            subcategory: "Desktop",
            description: "Main gaming and work system",
            improvements: [
                Improvement(
                    name: "Upgrade GPU",
                    status: .planned,
                    description: "Want to upgrade to RTX 4080 next month",
                    deviceId: UUID()
                ),
                Improvement(
                    name: "Add more RAM",
                    status: .completed,
                    description: "Upgraded from 16GB to 32GB DDR4",
                    deviceId: UUID()
                )
            ]
        ),
        Device(
            name: "PlayStation 5",
            category: .console,
            subcategory: "PlayStation",
            description: "Console for exclusive games",
            improvements: [
                Improvement(
                    name: "SSD Upgrade",
                    status: .planned,
                    description: "Need more storage space",
                    deviceId: UUID()
                )
            ]
        )
    ]
}
