import Foundation
import SwiftUI

struct DiaryEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var mood: MoodType?
    var text: String
    var emotions: [MoodType]
    var isFavorite: Bool
    var photoData: Data?
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        mood: MoodType? = nil,
        text: String = "",
        emotions: [MoodType] = [],
        isFavorite: Bool = false,
        photoData: Data? = nil
    ) {
        self.id = id
        self.date = date
        self.mood = mood
        self.text = text
        self.emotions = emotions
        self.isFavorite = isFavorite
        self.photoData = photoData
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    var preview: String {
        if text.isEmpty {
            return "No text"
        }
        return String(text.prefix(100))
    }
    
    var hasContent: Bool {
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || mood != nil
    }
}

extension DiaryEntry {
    static let sampleEntries: [DiaryEntry] = [
        DiaryEntry(
            date: Date().addingTimeInterval(-86400),
            mood: .happy,
            text: "Had a wonderful day today. The weather was perfect and I spent time in the garden.",
            emotions: [.happy, .grateful, .peaceful],
            isFavorite: true
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-172800),
            mood: .calm,
            text: "Feeling more centered after meditation this morning.",
            emotions: [.calm, .peaceful],
            isFavorite: false
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-259200),
            mood: .excited,
            text: "Starting a new project today! Feeling energized and ready.",
            emotions: [.excited, .happy],
            isFavorite: true
        )
    ]
    
    static let sampleDataForTesting: [DiaryEntry] = [
        DiaryEntry(
            date: Date().addingTimeInterval(-86400),
            mood: .happy,
            text: "Had a wonderful day today. The weather was perfect and I spent time in the garden. Small moments of joy really add up.",
            emotions: [.happy, .grateful, .peaceful],
            isFavorite: true
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-172800),
            mood: .calm,
            text: "Feeling more centered after meditation this morning. Taking time for myself makes such a difference.",
            emotions: [.calm, .peaceful],
            isFavorite: false
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-259200),
            mood: .excited,
            text: "Starting a new project today! Feeling energized and ready to take on new challenges.",
            emotions: [.excited, .happy],
            isFavorite: true
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-345600),
            mood: .tired,
            text: "Long day. Need to remember to rest and not push too hard. Rest is part of the process too.",
            emotions: [.tired, .calm],
            isFavorite: false
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-432000),
            mood: .grateful,
            text: "Grateful for my friends who checked in on me today. Connection matters so much.",
            emotions: [.grateful, .happy, .peaceful],
            isFavorite: true
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-518400),
            mood: .anxious,
            text: "Feeling a bit overwhelmed with everything on my plate. Writing this down helps. One step at a time.",
            emotions: [.anxious, .overwhelmed],
            isFavorite: false
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-604800),
            mood: .peaceful,
            text: "Quiet evening at home. Sometimes doing nothing is exactly what I need. No guilt about it.",
            emotions: [.peaceful, .calm, .grateful],
            isFavorite: true
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-691200),
            mood: .sad,
            text: "Not the best day. Allowed myself to feel it instead of pretending. Tomorrow can be different.",
            emotions: [.sad, .tired],
            isFavorite: false
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-777600),
            mood: .confused,
            text: "Lots of thoughts about the future. Not sure which path to take. That's okay for now.",
            emotions: [.confused, .anxious],
            isFavorite: false
        ),
        DiaryEntry(
            date: Date().addingTimeInterval(-864000),
            mood: .overwhelmed,
            text: "Too many things at once. Took a break and made a simple list. Feeling a bit more in control.",
            emotions: [.overwhelmed, .anxious],
            isFavorite: false
        )
    ]
}
