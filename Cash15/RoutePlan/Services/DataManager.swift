import Foundation

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var trips: [Trip] = []
    @Published var wishlistItems: [WishlistItem] = []
    
    private let tripsKey = "SavedTrips"
    private let wishlistKey = "SavedWishlist"
    
    private init() {
        loadData()
        if trips.isEmpty && wishlistItems.isEmpty && !UserDefaults.standard.bool(forKey: "HasLoadedSampleData") {
            UserDefaults.standard.set(true, forKey: "HasLoadedSampleData")
        }
    }
    
    func loadData() {
        loadTrips()
        loadWishlist()
    }
    
    private func loadTrips() {
        if let data = UserDefaults.standard.data(forKey: tripsKey),
           let decodedTrips = try? JSONDecoder().decode([Trip].self, from: data) {
            trips = decodedTrips
        }
    }
    
    private func loadWishlist() {
        if let data = UserDefaults.standard.data(forKey: wishlistKey),
           let decodedWishlist = try? JSONDecoder().decode([WishlistItem].self, from: data) {
            wishlistItems = decodedWishlist
        }
    }
    
    private func saveTrips() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: tripsKey)
        }
    }
    
    private func saveWishlist() {
        if let encoded = try? JSONEncoder().encode(wishlistItems) {
            UserDefaults.standard.set(encoded, forKey: wishlistKey)
        }
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
    
    func archiveTrip(_ trip: Trip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index].isArchived = true
            saveTrips()
        }
    }
    
    func deleteTrip(_ trip: Trip) {
        trips.removeAll { $0.id == trip.id }
        saveTrips()
    }
    
    func addWishlistItem(_ item: WishlistItem) {
        wishlistItems.append(item)
        saveWishlist()
    }
    
    func updateWishlistItem(_ item: WishlistItem) {
        if let index = wishlistItems.firstIndex(where: { $0.id == item.id }) {
            wishlistItems[index] = item
            saveWishlist()
        }
    }
    
    func deleteWishlistItem(_ item: WishlistItem) {
        wishlistItems.removeAll { $0.id == item.id }
        saveWishlist()
    }
    
    func toggleWishlistPriority(_ item: WishlistItem) {
        if let index = wishlistItems.firstIndex(where: { $0.id == item.id }) {
            wishlistItems[index].isPriority.toggle()
            saveWishlist()
        }
    }
    
    func getActiveTrips() -> [Trip] {
        return trips.filter { !$0.isArchived }
    }
    
    func getSortedWishlist() -> [WishlistItem] {
        return wishlistItems.sorted { first, second in
            if first.isPriority != second.isPriority {
                return first.isPriority
            }
            return first.title < second.title
        }
    }
    
    func getTripsForDate(_ date: Date) -> [Trip] {
        return getActiveTrips().filter { trip in
            let calendar = Calendar.current
            return date >= calendar.startOfDay(for: trip.startDate) &&
                   date <= calendar.startOfDay(for: trip.endDate)
        }
    }
}
