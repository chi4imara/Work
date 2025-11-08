import Foundation

struct TrackData: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var artist: String?
    var whereHeard: String
    var context: String?
    var whatReminds: String?
    var dateAdded: Date
    var createdAt: Date
    
    init(title: String, artist: String? = nil, whereHeard: WhereHeardOption, context: String? = nil, whatReminds: String? = nil, dateAdded: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.artist = artist
        self.whereHeard = whereHeard.rawValue
        self.context = context
        self.whatReminds = whatReminds
        self.dateAdded = dateAdded
        self.createdAt = Date()
    }
    
    init(from track: TrackData, title: String, artist: String?, whereHeard: WhereHeardOption, context: String?, whatReminds: String?, dateAdded: Date) {
        self.id = track.id
        self.title = title
        self.artist = artist
        self.whereHeard = whereHeard.rawValue
        self.context = context
        self.whatReminds = whatReminds
        self.dateAdded = dateAdded
        self.createdAt = track.createdAt
    }
}

enum WhereHeardOption: String, CaseIterable, Codable {
    case radio = "Radio"
    case cafe = "Cafe"
    case movie = "Movie"
    case series = "Series"
    case advertisement = "Advertisement"
    case concert = "Concert"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

enum SortOption: String, CaseIterable, Codable {
    case dateNewest = "Date Added (Newest)"
    case dateOldest = "Date Added (Oldest)"
    case titleAZ = "Title (A→Z)"
    case titleZA = "Title (Z→A)"
    case artistAZ = "Artist (A→Z)"
    case artistZA = "Artist (Z→A)"
    
    var displayName: String {
        return self.rawValue
    }
}

enum DateRange: String, CaseIterable, Codable {
    case all = "All"
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    case custom = "Custom"
    
    var displayName: String {
        return self.rawValue
    }
}
