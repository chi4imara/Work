import Foundation
import SwiftUI

struct CosmeticBag: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var purpose: BagPurpose
    var colorTag: BagColor
    var description: String
    var isActive: Bool
    var products: [Product]
    
    init(name: String, purpose: BagPurpose, colorTag: BagColor, description: String = "", isActive: Bool = false) {
        self.id = UUID()
        self.name = name
        self.purpose = purpose
        self.colorTag = colorTag
        self.description = description
        self.isActive = isActive
        self.products = []
    }
    
    var productCount: Int {
        products.count
    }
    
    var availableProductsCount: Int {
        products.filter { $0.status == .available }.count
    }
    
    var outOfStockProductsCount: Int {
        products.filter { $0.status == .outOfStock }.count
    }
}

enum BagPurpose: String, CaseIterable, Codable {
    case makeup = "Makeup"
    case skincare = "Skincare" 
    case mixed = "Mixed"
    
    var displayName: String {
        switch self {
        case .makeup:
            return "For Makeup"
        case .skincare:
            return "For Skincare"
        case .mixed:
            return "Mixed"
        }
    }
}

enum BagColor: String, CaseIterable, Codable {
    case blue = "Blue"
    case pink = "Pink"
    case gray = "Gray"
    case green = "Green"
    case purple = "Purple"
    case orange = "Orange"
    
    var color: Color {
        switch self {
        case .blue:
            return Color.theme.primaryBlue
        case .pink:
            return Color.pink
        case .gray:
            return Color.gray
        case .green:
            return Color.theme.accentGreen
        case .purple:
            return Color.theme.primaryPurple
        case .orange:
            return Color.theme.accentOrange
        }
    }
    
    var displayName: String {
        return self.rawValue
    }
}
