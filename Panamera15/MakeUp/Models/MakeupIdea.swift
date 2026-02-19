import Foundation
import UIKit

struct MakeupIdea: Identifiable, Codable {
    let id = UUID()
    var title: String
    var imageData: Data?
    var tags: [String]
    var description: String
    var isFavorite: Bool = false
    var createdAt: Date = Date()
    
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    var displayTags: [String] {
        Array(tags.prefix(2))
    }
}

extension MakeupIdea {
    static let sampleData: [MakeupIdea] = [
        MakeupIdea(
            title: "Evening Glam",
            tags: ["evening", "glam", "party"],
            description: "Perfect for special occasions with bold eyes and glossy lips."
        ),
        MakeupIdea(
            title: "Natural Day Look",
            tags: ["natural", "day", "office"],
            description: "Light and fresh makeup for everyday wear."
        ),
        MakeupIdea(
            title: "Smoky Eyes",
            tags: ["smoky", "dramatic", "night"],
            description: "Classic smoky eye look for evening events."
        )
    ]
}
