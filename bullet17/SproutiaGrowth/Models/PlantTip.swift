import Foundation

struct PlantTip: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let category: TipCategory
    let difficulty: TipDifficulty
    let season: TipSeason
    let icon: String
    
    enum TipCategory: String, CaseIterable, Codable {
        case watering = "watering"
        case lighting = "lighting"
        case fertilizing = "fertilizing"
        case repotting = "repotting"
        case pruning = "pruning"
        case troubleshooting = "troubleshooting"
        
        var displayName: String {
            switch self {
            case .watering: return "💧 Watering"
            case .lighting: return "☀️ Lighting"
            case .fertilizing: return "🌿 Fertilizing"
            case .repotting: return "🪴 Repotting"
            case .pruning: return "✂️ Pruning"
            case .troubleshooting: return "🔧 Troubleshooting"
            }
        }
    }
    
    enum TipDifficulty: String, CaseIterable, Codable {
        case beginner = "beginner"
        case intermediate = "intermediate"
        case advanced = "advanced"
        
        var displayName: String {
            switch self {
            case .beginner: return "🟢 Beginner"
            case .intermediate: return "🟡 Intermediate"
            case .advanced: return "🔴 Advanced"
            }
        }
    }
    
    enum TipSeason: String, CaseIterable, Codable {
        case spring = "spring"
        case summer = "summer"
        case autumn = "autumn"
        case winter = "winter"
        case all = "all"
        
        var displayName: String {
            switch self {
            case .spring: return "🌸 Spring"
            case .summer: return "☀️ Summer"
            case .autumn: return "🍂 Autumn"
            case .winter: return "❄️ Winter"
            case .all: return "🌍 All Year"
            }
        }
    }
}
