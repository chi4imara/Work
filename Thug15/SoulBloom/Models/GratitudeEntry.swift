import Foundation
import SwiftUI

struct GratitudeEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var firstGratitude: String
    var secondGratitude: String
    var thirdGratitude: String
    let createdAt: Date
    
    init(date: Date, firstGratitude: String, secondGratitude: String, thirdGratitude: String) {
        self.date = date
        self.firstGratitude = firstGratitude
        self.secondGratitude = secondGratitude
        self.thirdGratitude = thirdGratitude
        self.createdAt = Date()
    }
    
    var isComplete: Bool {
        !firstGratitude.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !secondGratitude.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !thirdGratitude.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter.string(from: date)
    }
}
