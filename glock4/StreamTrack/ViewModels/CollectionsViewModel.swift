import Foundation
import Combine

class CollectionsViewModel: ObservableObject {
    @Published var collections: [MovieCollection] = []
    @Published var showingAddCollection = false
    @Published var showingError = false
    @Published var errorMessage = ""
    
    private let userDefaults = UserDefaults.standard
    private let collectionsKey = "SavedCollections"
    
    init() {
        loadCollections()
    }
    
    private func loadCollections() {
        if let data = userDefaults.data(forKey: collectionsKey),
           let decodedCollections = try? JSONDecoder().decode([MovieCollection].self, from: data) {
            collections = decodedCollections
        } else {
            collections = MovieCollection.predefinedCollections
            saveCollections()
        }
    }
    
    private func saveCollections() {
        if let encoded = try? JSONEncoder().encode(collections) {
            userDefaults.set(encoded, forKey: collectionsKey)
        }
    }
    
    func addCollection(_ collection: MovieCollection) {
        collections.append(collection)
        saveCollections()
    }
    
    func updateCollection(_ collection: MovieCollection) {
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[index] = collection
            saveCollections()
        }
    }
    
    func deleteCollection(_ collection: MovieCollection) {
        collections.removeAll { $0.id == collection.id }
        saveCollections()
    }
    
    func addMovieToCollection(_ movieId: UUID, collectionId: UUID) {
        if let index = collections.firstIndex(where: { $0.id == collectionId }) {
            if !collections[index].movieIds.contains(movieId) {
                collections[index].movieIds.append(movieId)
                saveCollections()
            }
        }
    }
    
    func removeMovieFromCollection(_ movieId: UUID, collectionId: UUID) {
        if let index = collections.firstIndex(where: { $0.id == collectionId }) {
            collections[index].movieIds.removeAll { $0 == movieId }
            saveCollections()
        }
    }
    
    func getMoviesForCollection(_ collection: MovieCollection, allMovies: [Movie]) -> [Movie] {
        return allMovies.filter { collection.movieIds.contains($0.id) }
    }
    
    func getCollectionsContainingMovie(_ movieId: UUID) -> [MovieCollection] {
        return collections.filter { $0.movieIds.contains(movieId) }
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}
