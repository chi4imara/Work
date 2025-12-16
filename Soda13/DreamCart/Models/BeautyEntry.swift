import Foundation

struct BeautyEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var procedureName: String
    var products: String
    var notes: String
    var isFavorite: Bool = false
    
    init(date: Date = Date(), procedureName: String = "", products: String = "", notes: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.date = date
        self.procedureName = procedureName
        self.products = products
        self.notes = notes
        self.isFavorite = isFavorite
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var hasNotes: Bool {
        !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension BeautyEntry {
    static let sampleEntries: [BeautyEntry] = [
        BeautyEntry(
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
            procedureName: "Morning Skincare",
            products: "Toner, Serum, Moisturizer",
            notes: "Great combination, skin feels hydrated"
        ),
        BeautyEntry(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            procedureName: "Hair Mask Treatment",
            products: "Deep conditioning mask, Hair oil",
            notes: "Hair feels softer and shinier"
        ),
        BeautyEntry(
            date: Date(),
            procedureName: "Evening Routine",
            products: "Cleanser, Night cream, Eye cream",
            notes: "Relaxing routine before bed"
        )
    ]
}
