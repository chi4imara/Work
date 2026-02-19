import Foundation

private struct AppStorageData: Codable {
    var hairstyles: [Hairstyle]
    var looks: [Look]
    var categories: [CustomCategory]
}

class DataManager {
    static let shared = DataManager()
    
    private let storageKey = "MyHairstyleAppStorage"
    
    private let encoder: JSONEncoder = {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .secondsSince1970
        return enc
    }()
    
    private let decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .secondsSince1970
        return dec
    }()
    
    private init() {}
    
    func saveAll(hairstyles: [Hairstyle], looks: [Look], categories: [CustomCategory]) {
        let container = AppStorageData(
            hairstyles: hairstyles,
            looks: looks,
            categories: categories
        )
        do {
            let data = try encoder.encode(container)
            UserDefaults.standard.set(data, forKey: storageKey)
            UserDefaults.standard.synchronize()
        } catch {
            assertionFailure("DataManager save failed: \(error)")
        }
    }
    
    func loadAll() -> (hairstyles: [Hairstyle], looks: [Look], categories: [CustomCategory]) {
        let data = UserDefaults.standard.data(forKey: storageKey)
        guard let data = data, !data.isEmpty else {
            return ([], [], [])
        }
        do {
            let container = try decoder.decode(AppStorageData.self, from: data)
            return (container.hairstyles, container.looks, container.categories)
        } catch {
            return ([], [], [])
        }
    }
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        UserDefaults.standard.synchronize()
    }
}
