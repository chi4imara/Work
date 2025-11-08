import Foundation

struct IdentifiableUUID: Identifiable {
    let id: UUID
    
    init(_ id: UUID) {
        self.id = id
    }
}
