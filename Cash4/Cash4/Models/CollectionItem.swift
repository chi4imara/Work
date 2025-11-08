import Foundation

struct CollectionItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var category: String
    var series: String
    var number: String
    var year: Int?
    var manufacturer: String
    var country: String
    var condition: String
    var quantity: Int
    var purchasePrice: Double?
    var purchaseDate: Date?
    var purchaseSource: String
    var currentValue: Double?
    var valueComment: String
    var storageLocation: String
    var isForTrade: Bool
    var needsVerification: Bool
    var isExclusive: Bool
    var setName: String
    var setPosition: String
    var ownershipHistory: String
    var certificates: String
    var tags: [String]
    var notes: String
    var dateAdded: Date
    var lastUpdated: Date
    
    init(name: String = "", category: String = "", series: String = "", number: String = "", year: Int? = nil, manufacturer: String = "", country: String = "", condition: String = "Good", quantity: Int = 1, purchasePrice: Double? = nil, purchaseDate: Date? = nil, purchaseSource: String = "", currentValue: Double? = nil, valueComment: String = "", storageLocation: String = "", isForTrade: Bool = false, needsVerification: Bool = false, isExclusive: Bool = false, setName: String = "", setPosition: String = "", ownershipHistory: String = "", certificates: String = "", tags: [String] = [], notes: String = "") {
        self.name = name
        self.category = category
        self.series = series
        self.number = number
        self.year = year
        self.manufacturer = manufacturer
        self.country = country
        self.condition = condition
        self.quantity = quantity
        self.purchasePrice = purchasePrice
        self.purchaseDate = purchaseDate
        self.purchaseSource = purchaseSource
        self.currentValue = currentValue
        self.valueComment = valueComment
        self.storageLocation = storageLocation
        self.isForTrade = isForTrade
        self.needsVerification = needsVerification
        self.isExclusive = isExclusive
        self.setName = setName
        self.setPosition = setPosition
        self.ownershipHistory = ownershipHistory
        self.certificates = certificates
        self.tags = tags
        self.notes = notes
        self.dateAdded = Date()
        self.lastUpdated = Date()
    }
}

extension CollectionItem {
    var profitLoss: Double? {
        guard let currentValue = currentValue, let purchasePrice = purchasePrice else { return nil }
        return currentValue - purchasePrice
    }
    
    var isDuplicate: Bool {
        return quantity > 1
    }
    
    var hasValue: Bool {
        return currentValue != nil && currentValue! > 0
    }
}
