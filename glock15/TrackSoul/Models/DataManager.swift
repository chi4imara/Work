import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var tracks: [TrackData] = []
    
    private let userDefaults = UserDefaults.standard
    private let tracksKey = "saved_tracks"
    
    private init() {
        loadTracks()
    }
    
    private func loadTracks() {
        if let data = userDefaults.data(forKey: tracksKey),
           let decodedTracks = try? JSONDecoder().decode([TrackData].self, from: data) {
            tracks = decodedTracks
        } else {
            tracks = []
        }
    }
    
    func refreshTracks() {
        loadTracks()
    }
    
    private func saveTracks() {
        if let encoded = try? JSONEncoder().encode(tracks) {
            userDefaults.set(encoded, forKey: tracksKey)
            objectWillChange.send()
        }
    }
    
    func addTrack(_ track: TrackData) {
        tracks.append(track)
        saveTracks()
    }
    
    func updateTrack(_ track: TrackData) {
        if let index = tracks.firstIndex(where: { $0.id == track.id }) {
            tracks[index] = track
            saveTracks()
        }
    }
    
    func deleteTrack(_ track: TrackData) {
        tracks.removeAll { $0.id == track.id }
        saveTracks()
    }
    
    func deleteAllTracks() {
        tracks.removeAll()
        saveTracks()
    }
    
    func filterTracks(
        searchText: String = "",
        whereHeard: WhereHeardOption? = nil,
        onlyWithReminders: Bool = false,
        dateRange: DateRange = .all,
        customStartDate: Date = Date(),
        customEndDate: Date = Date(),
        sortOption: SortOption = .dateNewest
    ) -> [TrackData] {
        
        var filtered = tracks
        
        if !searchText.isEmpty {
            filtered = filtered.filter { track in
                track.title.localizedCaseInsensitiveContains(searchText) ||
                (track.artist?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        if let whereHeard = whereHeard {
            filtered = filtered.filter { $0.whereHeard == whereHeard.rawValue }
        }
        
        if onlyWithReminders {
            filtered = filtered.filter { track in
                track.whatReminds != nil && !track.whatReminds!.isEmpty
            }
        }
        
        filtered = applyDateRangeFilter(to: filtered, dateRange: dateRange, customStartDate: customStartDate, customEndDate: customEndDate)
        
        filtered = applySorting(to: filtered, sortOption: sortOption)
        
        return filtered
    }
    
    private func applyDateRangeFilter(to tracks: [TrackData], dateRange: DateRange, customStartDate: Date, customEndDate: Date) -> [TrackData] {
        let calendar = Calendar.current
        let now = Date()
        
        switch dateRange {
        case .all:
            return tracks
        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            return tracks.filter { $0.dateAdded >= startOfDay && $0.dateAdded < endOfDay }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now)!
            return tracks.filter { $0.dateAdded >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return tracks.filter { $0.dateAdded >= monthAgo }
        case .custom:
            let startOfCustomStart = calendar.startOfDay(for: customStartDate)
            let endOfCustomEnd = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: customEndDate))!
            return tracks.filter { $0.dateAdded >= startOfCustomStart && $0.dateAdded < endOfCustomEnd }
        }
    }
    
    private func applySorting(to tracks: [TrackData], sortOption: SortOption) -> [TrackData] {
        switch sortOption {
        case .dateNewest:
            return tracks.sorted { $0.dateAdded > $1.dateAdded }
        case .dateOldest:
            return tracks.sorted { $0.dateAdded < $1.dateAdded }
        case .titleAZ:
            return tracks.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .titleZA:
            return tracks.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        case .artistAZ:
            return tracks.sorted { 
                let artist1 = $0.artist ?? "Unknown"
                let artist2 = $1.artist ?? "Unknown"
                return artist1.localizedCaseInsensitiveCompare(artist2) == .orderedAscending
            }
        case .artistZA:
            return tracks.sorted { 
                let artist1 = $0.artist ?? "Unknown"
                let artist2 = $1.artist ?? "Unknown"
                return artist1.localizedCaseInsensitiveCompare(artist2) == .orderedDescending
            }
        }
    }
    
    func getTracksByWhereHeard() -> [(WhereHeardOption, Int)] {
        let grouped = Dictionary(grouping: tracks) { WhereHeardOption(rawValue: $0.whereHeard) ?? .other }
        return WhereHeardOption.allCases.compactMap { option in
            if let count = grouped[option]?.count, count > 0 {
                return (option, count)
            }
            return nil
        }.sorted { $0.0.rawValue < $1.0.rawValue }
    }
    
    func getTracksByMonth() -> [(String, Int)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let grouped = Dictionary(grouping: tracks) { formatter.string(from: $0.dateAdded) }
        return grouped.map { ($0.key, $0.value.count) }
            .sorted { 
                let date1 = formatter.date(from: $0.0) ?? Date.distantPast
                let date2 = formatter.date(from: $1.0) ?? Date.distantPast
                return date1 > date2
            }
    }
}
