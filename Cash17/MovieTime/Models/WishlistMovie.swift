import Foundation
import CoreData

@objc(WishlistMovie)
public class WishlistMovie: NSManagedObject {
    
}

extension WishlistMovie {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WishlistMovie> {
        return NSFetchRequest<WishlistMovie>(entityName: "WishlistMovie")
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var genre: String?
    @NSManaged public var note: String?
    @NSManaged public var isPriority: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
}

extension WishlistMovie: Identifiable {
    
}

extension WishlistMovie {
    var shortNote: String {
        guard let note = note, !note.isEmpty else { return "No notes" }
        return note.count > 50 ? String(note.prefix(50)) + "..." : note
    }
}
