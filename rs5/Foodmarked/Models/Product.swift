import Foundation

enum ProductStatus: String, CaseIterable, Codable {
    case suitable = "suitable"
    case unsuitable = "unsuitable"
    
    var displayName: String {
        switch self {
        case .suitable:
            return "Suitable"
        case .unsuitable:
            return "Not Suitable"
        }
    }
    
    var shortName: String {
        switch self {
        case .suitable:
            return "Suitable"
        case .unsuitable:
            return "Not Suitable"
        }
    }
}

struct StatusChange: Codable, Equatable {
    let date: Date
    let status: ProductStatus
}

struct Product: Identifiable, Codable, Equatable {
    let id = UUID()
    var name: String
    var status: ProductStatus
    let dateAdded: Date
    var category: ProductCategory
    var isFavorite: Bool
    var statusHistory: [StatusChange]
    
    init(name: String, status: ProductStatus, category: ProductCategory? = nil) {
        self.name = name
        self.status = status
        self.dateAdded = Date()
        self.category = category ?? ProductCategory.detectCategory(from: name)
        self.isFavorite = false
        self.statusHistory = [StatusChange(date: Date(), status: status)]
    }
    
    mutating func toggleFavorite() {
        isFavorite.toggle()
    }
    
    mutating func changeStatus(_ newStatus: ProductStatus) {
        if status != newStatus {
            statusHistory.append(StatusChange(date: Date(), status: newStatus))
            status = newStatus
        }
    }
}