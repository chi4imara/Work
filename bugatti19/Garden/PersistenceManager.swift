import Foundation

struct AppPersistedData: Codable {
    var todayProgress: DailyProgress?
    var dailyChallenge: Challenge?
    var habits: [Habit]
    var dailyProgressHistory: [DailyProgress]
    
    static var empty: AppPersistedData {
        AppPersistedData(todayProgress: nil, dailyChallenge: nil, habits: [], dailyProgressHistory: [])
    }
}

enum PersistenceManager {
    private static let fileManager = FileManager.default
    private static let fileName = "app_data.json"
    
    private static var fileURL: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
    }
    
    static func load() -> AppPersistedData? {
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL) else { return nil }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(AppPersistedData.self, from: data)
    }
    
    static func save(_ data: AppPersistedData) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let encoded = try? encoder.encode(data) else { return }
        try? encoded.write(to: fileURL)
    }
}
