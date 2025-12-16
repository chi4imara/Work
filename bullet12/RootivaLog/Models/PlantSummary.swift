import Foundation

struct PlantSummary: Identifiable {
    let id = UUID()
    let plantName: String
    let recordCount: Int
    let lastRepotDate: Date
    
    var displayName: String {
        return plantName
    }
    
    var statusDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return "Records: \(recordCount) • Last: \(formatter.string(from: lastRepotDate))"
    }
}
