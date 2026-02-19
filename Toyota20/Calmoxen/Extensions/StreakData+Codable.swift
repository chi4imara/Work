import Foundation

extension StreakData: Codable {
    enum CodingKeys: String, CodingKey {
        case currentStreak
        case longestStreak
        case totalDays
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentStreak = try container.decode(Int.self, forKey: .currentStreak)
        longestStreak = try container.decode(Int.self, forKey: .longestStreak)
        totalDays = try container.decode(Int.self, forKey: .totalDays)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentStreak, forKey: .currentStreak)
        try container.encode(longestStreak, forKey: .longestStreak)
        try container.encode(totalDays, forKey: .totalDays)
    }
}