import Foundation

struct RepotStorage {
    private static let recordsKey = "repot_records_v1"

    static func loadRecords() -> [RepotRecord] {
        guard let data = UserDefaults.standard.data(forKey: recordsKey) else {
            return []
        }
        do {
            let decoded = try JSONDecoder().decode([RepotRecord].self, from: data)
            return decoded
        } catch {
            print("RepotStorage: failed to decode records: \(error)")
            return []
        }
    }

    static func saveRecords(_ records: [RepotRecord]) {
        do {
            let data = try JSONEncoder().encode(records)
            UserDefaults.standard.set(data, forKey: recordsKey)
        } catch {
            print("RepotStorage: failed to encode records: \(error)")
        }
    }
}


