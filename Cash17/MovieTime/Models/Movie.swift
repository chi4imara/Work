import Foundation
import CoreData

@objc(Movie)
public class Movie: NSManagedObject {
    
}

extension Movie {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var genre: String
    @NSManaged public var watchDate: Date
    @NSManaged public var rating: Int16
    @NSManaged public var review: String?
    @NSManaged public var watchLocation: String?
    @NSManaged public var notes: [String]
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isArchived: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
}

extension Movie: Identifiable {
    
}

extension Movie {
    var formattedWatchDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: watchDate)
    }
    
    var shortReview: String {
        guard let review = review, !review.isEmpty else { return "No review" }
        return review.count > 50 ? String(review.prefix(50)) + "..." : review
    }
    
    var ratingText: String {
        return "\(rating)/10"
    }
}
