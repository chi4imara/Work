import Foundation
import SwiftUI

struct Look: Identifiable, Codable {
    var id: UUID
    var name: String
    var photo: Data?
    var hairstyles: [Hairstyle]
    var dateCreated: Date
    var isFavorite: Bool
    
    init(id: UUID = UUID(), name: String, photo: Data? = nil, hairstyles: [Hairstyle] = [], dateCreated: Date = Date(), isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.photo = photo
        self.hairstyles = hairstyles
        self.dateCreated = dateCreated
        self.isFavorite = isFavorite
    }
}

struct CustomCategory: Identifiable, Codable {
    var id: UUID
    var name: String
    var isRepeating: Bool
    var dateCreated: Date
    
    init(id: UUID = UUID(), name: String, isRepeating: Bool = false, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.isRepeating = isRepeating
        self.dateCreated = dateCreated
    }
}