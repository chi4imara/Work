import Foundation
import SwiftUI
import Combine

class TripViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var selectedTrip: Trip?
    
    private let userDefaults = UserDefaults.standard
    private let tripsKey = "SavedTrips"
    
    init() {
        loadTrips()
    }
    
    func addTrip(_ trip: Trip) {
        trips.append(trip)
        saveTrips()
    }
    
    func updateTrip(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
            saveTrips()
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        trips.removeAll { $0.id == trip.id }
        saveTrips()
    }
    
    func deleteTrip(at indexSet: IndexSet) {
        trips.remove(atOffsets: indexSet)
        saveTrips()
    }
    
    func getTripCategories() -> [TripCategory] {
        let groupedTrips = Dictionary(grouping: trips) { $0.type }
        return TripType.allCases.compactMap { type in
            if let tripsForType = groupedTrips[type], !tripsForType.isEmpty {
                return TripCategory(type: type, trips: tripsForType)
            }
            return nil
        }
    }
    
    func getTrips(for type: TripType) -> [Trip] {
        return trips.filter { $0.type == type }
    }
    
    private func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            userDefaults.set(encoded, forKey: tripsKey)
        }
    }
    
    private func loadTrips() {
        if let data = userDefaults.data(forKey: tripsKey),
           let decodedTrips = try? JSONDecoder().decode([Trip].self, from: data) {
            trips = decodedTrips
        }
    }
    
    func isValidTrip(type: String, route: String, duration: String, groupComposition: String) -> Bool {
        return !type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !route.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !duration.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !groupComposition.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

class AppStateManager: ObservableObject {
    @Published var showSplash = true
    @Published var showOnboarding = false
    @Published var isFirstLaunch = true
    
    private let hasLaunchedKey = "HasLaunchedBefore"
    
    init() {
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !UserDefaults.standard.bool(forKey: hasLaunchedKey)
        showOnboarding = isFirstLaunch
    }
    
    func completeSplash() {
        showSplash = false
    }
    
    func completeOnboarding() {
        showOnboarding = false
        UserDefaults.standard.set(true, forKey: hasLaunchedKey)
    }
}
