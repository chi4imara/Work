import Foundation
import SwiftUI

struct CosmeticProduct: Identifiable, Codable, Equatable {
    let id = UUID()
    var name: String
    var brand: String
    var type: ProductType
    var shade: String
    var purchaseDate: Date
    var expirationDate: Date
    var rating: Int
    var comment: String
    var isFavorite: Bool = false
    
    var daysUntilExpiration: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
    }
    
    var expirationStatus: ExpirationStatus {
        let days = daysUntilExpiration
        if days < 0 {
            return .expired
        } else if days <= 90 {
            return .expiringSoon
        } else {
            return .active
        }
    }
    
    var statusColor: Color {
        switch expirationStatus {
        case .active:
            return AppColors.statusGreen
        case .expiringSoon:
            return AppColors.statusYellow
        case .expired:
            return AppColors.statusRed
        }
    }
}

enum ProductType: String, CaseIterable, Codable {
    case lipstick = "Lipstick"
    case foundation = "Foundation"
    case mascara = "Mascara"
    case eyeshadow = "Eyeshadow"
    case blush = "Blush"
    case concealer = "Concealer"
    case powder = "Powder"
    case eyeliner = "Eyeliner"
    case bronzer = "Bronzer"
    case highlighter = "Highlighter"
    case primer = "Primer"
    case setting_spray = "Setting Spray"
    case lip_gloss = "Lip Gloss"
    case brow_product = "Brow Product"
    case skincare = "Skincare"
    case perfume = "Perfume"
    case nail_polish = "Nail Polish"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .lipstick, .lip_gloss:
            return "paintbrush.fill"
        case .foundation, .concealer:
            return "drop.fill"
        case .mascara:
            return "eye.fill"
        case .eyeshadow:
            return "circle.grid.2x2.fill"
        case .blush, .bronzer:
            return "sun.max.fill"
        case .powder:
            return "circle.fill"
        case .eyeliner:
            return "pencil"
        case .highlighter:
            return "sparkles"
        case .primer, .setting_spray:
            return "waterbottle.fill"
        case .brow_product:
            return "line.3.horizontal"
        case .skincare:
            return "leaf.fill"
        case .perfume:
            return "aqi.medium"
        case .nail_polish:
            return "hand.raised.fill"
        case .other:
            return "star.fill"
        }
    }
}

enum ExpirationStatus: String, CaseIterable {
    case active = "Active"
    case expiringSoon = "Expiring Soon"
    case expired = "Expired"
}

struct FilterOptions {
    var selectedBrands: Set<String> = []
    var selectedTypes: Set<ProductType> = []
    var selectedStatuses: Set<ExpirationStatus> = []
    var minRating: Int = 1
    var maxRating: Int = 5
    
    var isActive: Bool {
        !selectedBrands.isEmpty || 
        !selectedTypes.isEmpty || 
        !selectedStatuses.isEmpty || 
        minRating > 1 || 
        maxRating < 5
    }
    
    mutating func reset() {
        selectedBrands.removeAll()
        selectedTypes.removeAll()
        selectedStatuses.removeAll()
        minRating = 1
        maxRating = 5
    }
}

enum SortOption: String, CaseIterable {
    case name = "Name"
    case brand = "Brand"
    case expirationDate = "Expiration Date"
    case rating = "Rating"
    case purchaseDate = "Purchase Date"
    
    var icon: String {
        switch self {
        case .name:
            return "textformat.abc"
        case .brand:
            return "building.2"
        case .expirationDate:
            return "calendar"
        case .rating:
            return "star"
        case .purchaseDate:
            return "cart"
        }
    }
}

struct PopularBrands {
    static let list = [
        "MAC", "NARS", "Urban Decay", "Too Faced", "Fenty Beauty",
        "Rare Beauty", "Charlotte Tilbury", "Dior", "Chanel", "YSL",
        "L'Oréal", "Maybelline", "Revlon", "CoverGirl", "Neutrogena",
        "The Ordinary", "Glossier", "Milk Makeup", "Benefit", "Tarte",
        "Anastasia Beverly Hills", "Huda Beauty", "Kylie Cosmetics"
    ].sorted()
}
