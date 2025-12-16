import Foundation
import UIKit

struct UserProfile: Codable {
    var name: String
    var avatarData: Data?
    var dateCreated: Date
    var lastUpdated: Date
    
    init(name: String = "", avatarData: Data? = nil) {
        self.name = name
        self.avatarData = avatarData
        self.dateCreated = Date()
        self.lastUpdated = Date()
    }
    
    var avatarImage: UIImage? {
        guard let data = avatarData else { return nil }
        return UIImage(data: data)
    }
    
    mutating func updateAvatar(_ image: UIImage) {
        self.avatarData = image.jpegData(compressionQuality: 0.8)
        self.lastUpdated = Date()
    }
    
    mutating func updateName(_ name: String) {
        self.name = name
        self.lastUpdated = Date()
    }
}
