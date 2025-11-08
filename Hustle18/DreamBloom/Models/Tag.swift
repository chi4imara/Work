import Foundation

struct Tag: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let isDefault: Bool
    
    init(name: String, isDefault: Bool = false) {
        self.name = name
        self.isDefault = isDefault
    }
}

extension Tag {
    static let defaultTags: [Tag] = [
        Tag(name: "scary", isDefault: true),
        Tag(name: "funny", isDefault: true),
        Tag(name: "vivid", isDefault: true),
        Tag(name: "beautiful", isDefault: true),
        Tag(name: "strange", isDefault: true),
        Tag(name: "lucid", isDefault: true)
    ]
}
