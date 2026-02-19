import Foundation
import SwiftUI
import Combine

struct Jewelry: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: JewelryType
    var suitableFor: String
    var notes: String
    var imageName: String?
    var dateCreated: Date
    
    init(name: String, type: JewelryType, suitableFor: String, notes: String = "", imageName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.suitableFor = suitableFor
        self.notes = notes
        self.imageName = imageName
        self.dateCreated = Date()
    }
}

enum JewelryType: String, CaseIterable, Codable {
    case earrings = "Earrings"
    case ring = "Ring"
    case bracelet = "Bracelet"
    case necklace = "Necklace"
    case watch = "Watch"
    case accessory = "Accessory"
    case bag = "Bag"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .earrings:
            return "circle.circle"
        case .ring:
            return "circle"
        case .bracelet:
            return "oval"
        case .necklace:
            return "link.circle"
        case .watch:
            return "clock"
        case .accessory:
            return "star"
        case .bag:
            return "bag"
        case .other:
            return "questionmark.circle"
        }
    }
}

struct JewelrySet: Identifiable, Codable {
    let id: UUID
    var name: String
    var jewelryIds: [UUID]
    var dateCreated: Date
    
    init(name: String, jewelryIds: [UUID] = []) {
        self.id = UUID()
        self.name = name
        self.jewelryIds = jewelryIds
        self.dateCreated = Date()
    }
}

class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var isLoading: Bool = true
    
    init() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
    
    func finishLoading() {
        isLoading = false
    }
}
