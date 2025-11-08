import Foundation
import SwiftUI
import Combine

class TrackViewModel: ObservableObject {
    @Published var tracks: [TrackData] = []
    @Published var filteredTracks: [TrackData] = []
    @Published var searchText = ""
    @Published var selectedWhereHeard: WhereHeardOption?
    @Published var onlyWithReminders = false
    @Published var selectedDateRange: DateRange = .all
    @Published var customStartDate = Date()
    @Published var customEndDate = Date()
    @Published var sortOption: SortOption = .dateNewest
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        fetchTracks()
    }
    
    private func setupBindings() {
        dataManager.$tracks
            .assign(to: \.tracks, on: self)
            .store(in: &cancellables)
        
        dataManager.$tracks
            .sink { [weak self] _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func fetchTracks() {
        isLoading = true
        tracks = dataManager.tracks
        applyFilters()
        isLoading = false
    }
    
    func addTrack(title: String, artist: String?, whereHeard: WhereHeardOption, context: String?, whatReminds: String?, dateAdded: Date) {
        let newTrack = TrackData(
            title: title,
            artist: artist?.isEmpty == true ? nil : artist,
            whereHeard: whereHeard,
            context: context?.isEmpty == true ? nil : context,
            whatReminds: whatReminds?.isEmpty == true ? nil : whatReminds,
            dateAdded: dateAdded
        )
        dataManager.addTrack(newTrack)
        DispatchQueue.main.async {
            self.fetchTracks()
        }
    }
    
    func updateTrack(_ track: TrackData, title: String, artist: String?, whereHeard: WhereHeardOption, context: String?, whatReminds: String?, dateAdded: Date) {
        let updatedTrack = TrackData(
            from: track,
            title: title,
            artist: artist?.isEmpty == true ? nil : artist,
            whereHeard: whereHeard,
            context: context?.isEmpty == true ? nil : context,
            whatReminds: whatReminds?.isEmpty == true ? nil : whatReminds,
            dateAdded: dateAdded
        )
        dataManager.updateTrack(updatedTrack)
        DispatchQueue.main.async {
            self.fetchTracks()
        }
    }
    
    func deleteTrack(_ track: TrackData) {
        dataManager.deleteTrack(track)
        DispatchQueue.main.async {
            self.fetchTracks()
        }
    }
    
    func deleteAllTracks() {
        dataManager.deleteAllTracks()
        DispatchQueue.main.async {
            self.fetchTracks()
        }
    }
    
    func applyFilters() {
        filteredTracks = dataManager.filterTracks(
            searchText: searchText,
            whereHeard: selectedWhereHeard,
            onlyWithReminders: onlyWithReminders,
            dateRange: selectedDateRange,
            customStartDate: customStartDate,
            customEndDate: customEndDate,
            sortOption: sortOption
        )
    }
    
    func clearFilters() {
        searchText = ""
        selectedWhereHeard = nil
        onlyWithReminders = false
        selectedDateRange = .all
        customStartDate = Date()
        customEndDate = Date()
        applyFilters()
    }
    
    func hasActiveFilters() -> Bool {
        return !searchText.isEmpty || 
               selectedWhereHeard != nil || 
               onlyWithReminders || 
               selectedDateRange != .all
    }
    
    func getTracksByWhereHeard() -> [(WhereHeardOption, Int)] {
        return dataManager.getTracksByWhereHeard()
    }
    
    func getTracksByMonth() -> [(String, Int)] {
        return dataManager.getTracksByMonth()
    }
}
