import Foundation

enum TestStatus: String, CaseIterable, Codable {
    case recommend = "recommend"
    case notSuitable = "not_suitable"
    case testing = "testing"
    
    var displayName: String {
        switch self {
        case .recommend:
            return "Recommend"
        case .notSuitable:
            return "Not Suitable"
        case .testing:
            return "Still Testing"
        }
    }
    
    var icon: String {
        switch self {
        case .recommend:
            return "checkmark.circle.fill"
        case .notSuitable:
            return "xmark.circle.fill"
        case .testing:
            return "clock.circle.fill"
        }
    }
}

enum Category: String, CaseIterable, Codable {
    case skincare = "skincare"
    case makeup = "makeup"
    case hair = "hair"
    case body = "body"
    case fragrance = "fragrance"
    
    var displayName: String {
        switch self {
        case .skincare:
            return "Skincare"
        case .makeup:
            return "Makeup"
        case .hair:
            return "Hair"
        case .body:
            return "Body"
        case .fragrance:
            return "Fragrance"
        }
    }
}

enum SkinType: String, CaseIterable, Codable {
    case dry = "dry"
    case oily = "oily"
    case combination = "combination"
    case sensitive = "sensitive"
    case normal = "normal"
    case coloredHair = "colored_hair"
    case curlyHair = "curly_hair"
    case straightHair = "straight_hair"
    
    var displayName: String {
        switch self {
        case .dry:
            return "Dry"
        case .oily:
            return "Oily"
        case .combination:
            return "Combination"
        case .sensitive:
            return "Sensitive"
        case .normal:
            return "Normal"
        case .coloredHair:
            return "Colored Hair"
        case .curlyHair:
            return "Curly Hair"
        case .straightHair:
            return "Straight Hair"
        }
    }
}

struct TestModel: Identifiable, Codable {
    let id: UUID
    var productName: String
    var brand: String
    var category: Category
    var skinType: SkinType
    var testDate: Date
    var effect: String
    var rating: Int
    var status: TestStatus
    var comment: String
    
    init(
        productName: String = "",
        brand: String = "",
        category: Category = .skincare,
        skinType: SkinType = .normal,
        testDate: Date = Date(),
        effect: String = "",
        rating: Int = 3,
        status: TestStatus = .testing,
        comment: String = ""
    ) {
        self.id = UUID()
        self.productName = productName
        self.brand = brand
        self.category = category
        self.skinType = skinType
        self.testDate = testDate
        self.effect = effect
        self.rating = rating
        self.status = status
        self.comment = comment
    }
}

enum SortOption: String, CaseIterable {
    case date = "date"
    case brand = "brand"
    case category = "category"
    case rating = "rating"
    
    var displayName: String {
        switch self {
        case .date:
            return "Date"
        case .brand:
            return "Brand"
        case .category:
            return "Category"
        case .rating:
            return "Rating"
        }
    }
}
