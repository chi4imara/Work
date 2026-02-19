import Foundation

struct SPASalon: Identifiable, Codable {
    var id: UUID
    let name: String
    let rating: Double
    let reviewCount: Int
    let distance: Double
    let imageURL: String
    let availableServices: [SPAService]
    let priceRange: PriceRange
    let hasDiscount: Bool
    let discountPercentage: Int?
    
    init(id: UUID = UUID(), name: String, rating: Double, reviewCount: Int, distance: Double, imageURL: String, availableServices: [SPAService], priceRange: PriceRange, hasDiscount: Bool, discountPercentage: Int?) {
        self.id = id
        self.name = name
        self.rating = rating
        self.reviewCount = reviewCount
        self.distance = distance
        self.imageURL = imageURL
        self.availableServices = availableServices
        self.priceRange = priceRange
        self.hasDiscount = hasDiscount
        self.discountPercentage = discountPercentage
    }
    
    var formattedDistance: String {
        if distance < 1 {
            return "\(Int(distance * 1000))m away"
        } else {
            return String(format: "%.1fkm away", distance)
        }
    }
    
    var formattedRating: String {
        return String(format: "%.1f", rating)
    }
}

struct SPAService: Identifiable, Codable {
    var id: UUID
    let name: String
    let duration: Int
    let price: Double
    let category: ServiceCategory
    let description: String
    
    init(id: UUID = UUID(), name: String, duration: Int, price: Double, category: ServiceCategory, description: String) {
        self.id = id
        self.name = name
        self.duration = duration
        self.price = price
        self.category = category
        self.description = description
    }
}

enum ServiceCategory: String, CaseIterable, Codable {
    case massage = "Massage"
    case facial = "Facial Care"
    case bodyWrap = "Body Wrap"
    case manicure = "Manicure"
    case pedicure = "Pedicure"
    case aromatherapy = "Aromatherapy"
    
    var icon: String {
        switch self {
        case .massage: return "figure.walk"
        case .facial: return "face.smiling"
        case .bodyWrap: return "heart.fill"
        case .manicure: return "hand.raised.fill"
        case .pedicure: return "figure.walk"
        case .aromatherapy: return "leaf.fill"
        }
    }
}

enum PriceRange: String, CaseIterable, Codable {
    case budget = "$"
    case moderate = "$$"
    case premium = "$$$"
    case luxury = "$$$$"
    
    var description: String {
        switch self {
        case .budget: return "Budget-friendly"
        case .moderate: return "Moderate pricing"
        case .premium: return "Premium services"
        case .luxury: return "Luxury experience"
        }
    }
}

struct Booking: Identifiable, Codable {
    var id: UUID
    let salonName: String
    let serviceName: String
    let masterName: String
    let date: Date
    let duration: Int
    let price: Double
    var status: BookingStatus
    
    init(id: UUID = UUID(), salonName: String, serviceName: String, masterName: String, date: Date, duration: Int, price: Double, status: BookingStatus) {
        self.id = id
        self.salonName = salonName
        self.serviceName = serviceName
        self.masterName = masterName
        self.date = date
        self.duration = duration
        self.price = price
        self.status = status
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedPrice: String {
        return String(format: "$%.0f", price)
    }
}

enum BookingStatus: String, CaseIterable, Codable {
    case scheduled = "Scheduled"
    case completed = "Completed"
    case cancelled = "Cancelled"
    case missed = "Missed"
    
    var color: String {
        switch self {
        case .scheduled: return "blue"
        case .completed: return "green"
        case .cancelled: return "red"
        case .missed: return "orange"
        }
    }
}

struct UserProfile: Codable {
    var name: String
    var email: String
    var avatarURL: String?
    var favoriteServices: [ServiceCategory]
    var favoriteSalon: String?
    var notificationsEnabled: Bool
    var visitGoal: Int
    
    init() {
        self.name = ""
        self.email = ""
        self.avatarURL = nil
        self.favoriteServices = []
        self.favoriteSalon = nil
        self.notificationsEnabled = true
        self.visitGoal = 4
    }
}

struct FilterOptions {
    var maxDistance: Double = 10.0
    var priceRange: PriceRange?
    var minRating: Double = 0.0
    var serviceCategories: Set<ServiceCategory> = []
    var showDiscountsOnly: Bool = false
    
    func matches(salon: SPASalon) -> Bool {
        if salon.distance > maxDistance {
            return false
        }
        
        if let priceRange = priceRange, salon.priceRange != priceRange {
            return false
        }
        
        if salon.rating < minRating {
            return false
        }
        
        if !serviceCategories.isEmpty {
            let salonCategories = Set(salon.availableServices.map { $0.category })
            if serviceCategories.isDisjoint(with: salonCategories) {
                return false
            }
        }
        
        if showDiscountsOnly && !salon.hasDiscount {
            return false
        }
        
        return true
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    let progress: Double
    
    var progressPercentage: Int {
        return Int(progress * 100)
    }
}

struct VisitStatistics {
    let totalVisits: Int
    let currentMonthVisits: Int
    let favoriteService: ServiceCategory?
    let averageSpending: Double
    let visitGoalProgress: Double 
    let achievements: [Achievement]
    
    var formattedAverageSpending: String {
        return String(format: "$%.0f", averageSpending)
    }
    
    var visitGoalPercentage: Int {
        return Int(visitGoalProgress * 100)
    }
}
