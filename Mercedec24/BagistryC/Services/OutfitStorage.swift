import Foundation

enum OutfitStorage {
    private static let key = "outfitBagIds"
    
    private static var defaults: UserDefaults { UserDefaults.standard }
    
    private static let encoder: JSONEncoder = JSONEncoder()
    private static let decoder: JSONDecoder = JSONDecoder()
    
    static func outfitBagIds() -> [UUID] {
        guard let data = defaults.data(forKey: key),
              let ids = try? decoder.decode([UUID].self, from: data) else {
            return []
        }
        return ids
    }
    
    static func addBag(_ id: UUID) {
        var ids = outfitBagIds()
        if !ids.contains(id) {
            ids.append(id)
            save(ids)
        }
    }
    
    static func removeBag(_ id: UUID) {
        var ids = outfitBagIds()
        ids.removeAll { $0 == id }
        save(ids)
    }
    
    static func contains(_ id: UUID) -> Bool {
        outfitBagIds().contains(id)
    }
    
    private static func save(_ ids: [UUID]) {
        guard let data = try? encoder.encode(ids) else { return }
        defaults.set(data, forKey: key)
    }
}
